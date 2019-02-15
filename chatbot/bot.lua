local M = {}
local contractions = require "chatbot.contractions"

-------------------------------------------------

local function find_node(id, root)
	if root.id == id then
		return root
	end
	
	if not root.nodes then
		return nil
	end
	
	for _, node in ipairs(root.nodes) do
		local test = find_node(id, node)
		if test then
			return test
		end 
	end
	
	return nil
end

-------------------------------------------------

local function format_output(text, state)
	if not text:find("%[") then
		return text
	end
	
	local output = text
	for key, value in pairs(state) do
		output = output:gsub("%[" .. key .. "%]", tostring(value))
	end
	
	return output
end

-------------------------------------------------

local function apply_state(bot)
	if bot.current.msg then
		local key = bot.current.msg[1]
		local value = bot.current.msg[2] or {}
		local target = bot.current.msg[3] or "."
		msg.post(target, key, value)
	end
	
	if not bot.current.state then
		return
	end
	
	for key, value in pairs(bot.current.state) do
		if type(value) == "string" and value:find("+") == 1 then
			bot.state[key] = bot.state[key] or 0
			bot.state[key] = bot.state[key] + tonumber(value:sub(2))
		elseif type(value) == "string" and value:find("-") == 1 then
			bot.state[key] = bot.state[key] or 0
			bot.state[key] = bot.state[key] - tonumber(value:sub(2))
		else
			bot.state[key] = value
		end
	end
	
	msg.post(".", "state_changed", bot.state)
end

-------------------------------------------------

local function apply_node(node, bot)
	bot.current = node
	apply_state(bot)

	local output = node.response
	if type(output) == "table" then
		local idx = math.random(#output)
		output = output[idx]
	end

	output = format_output(output, bot.state)

	if bot.current.goto then --
		bot.current = find_node(bot.current.goto, bot.data)
		apply_state(bot)
	elseif not bot.current.nodes and #bot.stack > 0 then -- return back to previous activity
		bot.current = bot.stack[1]
		table.remove(bot.stack, 1)
		if bot.current.segue then
			return output, format_output(bot.current.segue, bot.state)
		end
	end

	return output
end

-------------------------------------------------

local function is_empty(value)
	return (value == nil) or (value == 0) or (value == false) 
end

-------------------------------------------------

local function check_condition(condition, state)
	if not condition then
		return true
	end
	
	local get_suffix = function(s)
		local suffix_idx = string.find(string.reverse(s), "_")
		local suffix = nil
		local base = s
		if suffix_idx then
			suffix = string.sub(s, -suffix_idx, -1)
			base = string.sub(s, 1, #s - suffix_idx)
		end
		return base, suffix
	end
	
	if condition.OR then
		for key, value in pairs(condition.OR) do
			if (type(value) == "string") and (value:sub(1,1) == "<") then
				return (tonumber(state[key]) or 0) < tonumber(value:sub(2))
			end
			if (type(value) == "string") and (value:sub(1,1) == ">") then
				return (tonumber(state[key]) or 0) > tonumber(value:sub(2))
			end
			if (state[key] == value) or (is_empty(state[key]) and is_empty(value)) then
				return true
			end
		end
		return false
	elseif condition.AND then
		for key, value in pairs(condition.AND) do
			if state[key] ~= value then
				return false
			end
		end
		return true
	end
	
	return true
end

-------------------------------------------------

local function check_polarity(rule, input)
	local negatives = {"don't", "do not", "am not", "i'm not", "is not", "isn't"}
	local test_rule = " " .. rule:lower() .. " "
	local test_input = " " .. input:lower() .. " "
	local rule_is_negative = 0
	local input_is_negative = 0

	for _, val in ipairs(negatives) do
		rule_is_negative = test_rule:find("%W+" .. val .. "%W+")  or rule_is_negative 
		input_is_negative = test_input:find("%W+" .. val .. "%W+") or input_is_negative 
	end

	return (input_is_negative > 0) == (rule_is_negative > 0)
end

-------------------------------------------------

local function check_word(word, input, idx)

	local test = " " .. input .. " " -- to avoid check end\begin line pattern
	local pattern = string.gsub(word, "%-", "%%%-")
	local found =  test:find("%W+" .. pattern .. "s?%W+", idx)

	if not found then --past tense
		found =  test:find("%W+" .. pattern .. "?ed%W+", idx)
	end

	if not found then --continious
		found =  test:find("%W+" .. pattern .. "?ing%W+", idx)
	end

	if found then
		return found + #word
	end

	return 0
end

-------------------------------------------------

local function check_rule(rule, input, bot, contractions_applied)
	
	if not rule then
		return true --fallback
	end
	
	if not contractions_applied then
		rule, contractions_applied = contractions.apply(rule)
	end
	
	if type(rule) == "table" then
		local test = false
		for _, single_rule in ipairs(rule) do
			test = test or check_rule(single_rule, input, bot, contractions_applied)
		end
		return test
	end
	
	local idx = 0
	
	--TODO: combine any number of intents
	local intent_name = rule:match("#(%w+_*%w*)")
	if intent_name then
		local rules = {}
		local pattern = "#" .. intent_name
		for _, intent in ipairs(bot.library[intent_name]) do
			local new_rule = string.gsub(rule, pattern, intent)
			table.insert(rules, new_rule)
		end
		return check_rule(rules, input, bot)
	end
	
	for word in string.gmatch(rule, "%S+") do
		local found = 0
		local count, name = word:match("%[(%d+)=(%w+)%]")
		
		if name then -- capture input
			local template = "%W*(%w+"
			for i = 2, count do
				template = template .. "%W+%w+"
			end
			template = template .. ")"

			found, _, value = input:find(template, idx)
			bot.state[name] = value
			idx = found
		else
			count, name = word:match("%[number=(%d+)%+=(%w+)%]")
			found, _, value = input:find("(%d+)", idx)
			
			if name and value and tonumber(value) >= tonumber(count) then
				bot.state[name] = value
				idx = found or 0
			else
				found = 0
				name = word:match("%[number=(%a+%w+)%]")
			
				if name then -- capture number
					found, _, value = input:find("(%d+)", idx)
					if found then
						bot.state[name] = tonumber(value)
					end
					found = found or 0
					idx = found
				else
					found = check_word(word:lower(), input:lower(), idx)
					idx = found
				end
			end
		end

		if found == 0 then
		return false
		end
	end

	--Polarity detection 
	return check_polarity(rule, input)
end

-------------------------------------------------

local function apply_interjection(text, bot)
	local parent = bot.current.parent
	while parent do 
		for i, node in ipairs(parent.nodes) do
			if node.interjection 
			and check_condition(node.condition, bot.state) 
			and check_rule(node.rule, text, bot) then

				-- need to check if this interjection is already on stack

				local is_ok = bot.current.rule ~= node.rule
				for _, stacked in ipairs(bot.stack) do
					if stacked.rule == node.rule then
						is_ok = false
						break
					end
				end

				if is_ok then
					node.parent = parent
					table.insert(bot.stack, 1, bot.current)
					return apply_node(node, bot)
				end
			end
		end
		parent = parent.parent
	end

	return nil
end

-------------------------------------------------

local function say(text, bot)
	if not bot.current then
		return apply_node(bot.data, bot)
	end

	if bot.current.nodes then
		for i, node in ipairs(bot.current.nodes) do
			if check_condition(node.condition, bot.state) 
			and check_rule(node.rule, text, bot) then
				node.parent = bot.current
				if not node.rule then 
					local s1, s2 = apply_interjection(text, bot)
					if s1 then
						return s1, s2
					end
				end
				if not node.response and node.goto then -- change current node and check rules again
					bot.current = find_node(node.goto, bot.data)
					apply_state(bot)
					return say(text, bot)
				end
				return apply_node(node, bot)
			end
		end
	end

	return apply_interjection(text, bot)
end

-------------------------------------------------

M.init = function(data, library)
	local bot = {state = {}, stack = {}}
	bot.data = data
	if not data then
		bot.data = require "chatbot.sample"
	end
	
	bot.library = library
	if not library then
		bot.library = require "chatbot.intent_library"
	end
	
	bot.say = function (text)
		return say(text, bot)
	end
	
	math.randomseed( os.time() * 10000000 )
	return bot
end

return M