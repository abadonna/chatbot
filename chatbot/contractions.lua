local M = {}

local list = 
{
	{"do not", "don't", "does not", "doesn't", "did not", "didn't"},
	{"i am not", "i'm not"},
	{"is not", "isn't"},
	{"be", "is", "are", "was", "were", "been"},
	{"i", "me"},
	{"have", "has", "had"},
	{"do", "did", "done"},
	{"say", "said"},
	{"go", "went", "gone"},
	{"get", "got"},
	{"make", "made"},
	{"know", "knew", "known"},
	{"think", "thought"},
	{"take", "took"},
	{"see", "saw", "seen"},
	{"come", "came"},
	{"become", "became"},
	{"find", "found"},
	{"give", "gave", "given"},
	{"tell", "told"},
	{"try", "tried"},
	{"feel", "felt"},
	{"leave", "left"},
	{"mean", "meant"},
	{"keep", "kept"},
	{"begin", "began", "begun"},
	{"show", "shown"},
	{"hear", "heard"},
	{"run", "ran"},
	{"bring", "brought"},
	{"write", "wrote", "written"},
	{"sit", "sat"},
	{"stand", "stood"},
	{"lose", "lost"},
	{"pay", "paid"},
	{"meet", "met"},
	{"learn", "learnt"},
	{"lead", "led"},
	{"speak", "spoke", "spoken"},
	{"grow", "grew", "grown"},
	{"win", "won"},
	{"teach", "taught"},
	{"buy", "bought"},
	{"send", "sent"},
	{"build", "built"},
	{"fall", "fell"},
	{"sell", "sold"},
	{"break", "broke"},
	{"eat", "ate", "eaten"},
	{"catch", "caught"},
	{"draw", "drew"},
	{"choose", "chose", "chosen"},
	{"tits", "boobs"},
	{"0", "zero"},
	{"1", "one"},
	{"2", "two"},
	{"3", "three"},
	{"4", "four"},
	{"5", "five"},
	{"6", "six"},
	{"7", "seven"},
	{"8", "eight"},
	{"9", "nine"},
	{"10", "ten"},
	{"100", "one hundred", "hundred"},
	{"200", "two hundred"},
	{"300", "three hundred"},
	{"400", "four hundred"},
	{"500", "five hundred"},
	{"600", "six hundred"},
	{"700", "seven hundred"},
	{"800", "eight hundred"},
	{"900", "nine hundred"},
	{"1000", "one thousand", "thousand"},
	{"2000", "two thousand"},
	{"3000", "three thousand"},
	{"4000", "four thousand"},
	{"5000", "five thousand"},
	{"6000", "six thousand"},
	{"7000", "seven thousand"},
	{"8000", "eight thousand"},
	{"9000", "nine thousand"},
	{"yes", "yes+"},
	{"no", "no+"}
	
}

M.apply = function(rule)
	if type(rule) == "table" or rule:find("#") == 1 or rule:find("%[") == 1 then
		return rule, false
	end
	
	--proceed simple rule
	local result = {" " .. rule .. " "}
	
	for _, set in ipairs(list) do
		for i = 1, #result do
			local test = result[i]
			for _, word in ipairs(set) do
				if test:find("%W+" .. word .. "%W+") then
					for _, replace in ipairs(set) do
						if replace ~= word then
							local new_rule = test:gsub("([^#])" .. word, "%1" .. replace)
							table.insert(result, new_rule)
						end
					end
				end
			end
		end
	end
	
	if #result > 1 then
		return result, true
	end
	
	return rule, false
end

return M
