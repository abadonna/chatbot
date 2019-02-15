return
{
	id = "name",
	response = "What's your name?",
	state = {FOO = 1, BAR = "+1"},
	nodes = 
	{
		{
			rule = "#provide_name",
			id = "seasons",
			response = "What's your favorite season, [NAME]?",
			segue = "But what about seasons?",
			nodes = 
			{
				{ 
					rule = "winter",
					response = "Winter's great. I love sitting by the fire when it's snowing.",
					goto = "seasons"
				},
				{ 
					rule = "spring",
					response = "Gotta love spring, all those flowers in bloom.",
					goto = "seasons"
				},
				{ 
					rule = "summer",
					response = "There is nothing like a cold glass of lemonade on a hot summer day.",
					goto = "seasons"
				},
				{ 
					rule = {"fall", "autumn"},
					response = "I love watching the leaves change colors in the fall.",
					goto = "seasons"
				},
				
				{ 
					rule = "not sure",
					response = {"Oh, come on!", "Me too..", "..."},
					goto = "seasons"
				},
				{ 
					rule = "do not know",
					response = "Please, try!",
					goto = "seasons"
				},
				{
					rule = "#greetings",
					response = "Hello. How are you?",
					goto = "seasons"
				},
				
				{
					response = "You gotta have a favorite! Is it winter, sping, summer or fall?",
					goto = "seasons"
				}
				
			}
		},
		
		{ 
			rule = "not sure",
			response = {"Oh, come on!", "Me too..", "..."}
		},
		
		--interjections and conditions
		{ 
			rule = "like pizza",
			response = "Yeah, me too!",
			interjection = true,
			condition = {OR={PIZZA = false}},
			state = {PIZZA = true}
		},
		{ 
			rule = "like pizza",
			response = "Yes, you told me before, [NAME]!",
			interjection = true,
			condition = {OR={PIZZA = true}}
		},
		
		{ 
			rule = "ice cream",
			response = "Ice cream? I like chocolate and you?",
			interjection = true,
			nodes = 
			{
				{ 
					rule = "vanilla",
					response = "Vanilla is also good!"
				},
				{ 
					response = "Mmm... whatever"
				}
			}
		},
		
		--fallback
		{
			response = "please enter your REAL name",
			goto = "name"
		}
		
	}
}