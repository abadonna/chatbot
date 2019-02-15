-- local extra_nodes = require "blablabla"
-- you can separate logic in different modules

return
{
	id = "name",
	response = "Hey there, Handsome!\nWhat's your name?",
	msg = {"girl", {image = "level1"}},
	nodes = 
	{
		{
			rule = {"you","your","yours"},
			response = "I'm Claire. What's your name..?",
			goto = "name"
		},
		
		{
			rule = "#provide_name",
			id = "occupation",
			response = "Nice to meet you, [NAME]. I'm Claire, an actress. What about you..?",
			segue = "I'm curious, what is it you do here?",
			nodes = 
			{
				{ 
					rule = "boss",
					response = "Hmm... You look more like a pimp to me. Either way, do you have enough pull to get a part in a movie?",
					goto = "help"
				},
				
				{ 
					rule = {"pusher", "drug"},
					response = "I've got no interest in drugs, but are any of your clients directors or producers? If they can help me to get a role, we can talk...",
					goto = "help"
				},
				{ 
					rule = {"porn", "adult"},
					response = "You work in porn? That's... not what I was expecting. Still, can you help me to get a part in it?",
					goto = "help"
				},
				{ 
					id = "help",
					rule = {"producer","director","agent","actor","pornactor","pornstar", "star", "acting", "actress", 
					"that me", "producing", "movie", "film", "i do", "casting"},
					response = "I want get a foot into Hollywood. I'll act in any film you want me to. Can you help me?",
					msg = {"girl", {image = "level2"}},
					segue = "Can you help me to get a role in a film?",
					nodes = 
					{
						{ 
							rule = {"#yes", "i can", "i could", "i might", "let me see", "lets see"},
							response = "Cool!\nWhat studio do you work for?",
							segue = "But what studio do you work for?",
							id = "studio",
							nodes = 
							{
								{ 
									rule = "brazzers",
									response = "Brothers? Ah, you mean Warner Bros! What kind of movies do you produce?",
									goto = "movies"
								},
								{ 
									rule = {"warner", "dreamworks", "century fox", "mayer", "paramount", "disney", "universal", "mgm",
											"pixar", "hollywood", "holywood"},
									response = "Do I look stupid to you? Tell me the real name of the studio you work for.",
									goto = "studio"
								},
								{ 
									rule = "porn",
									response = "Porn? That's not really what I was hoping for, but I have to start my career somewhere. How much do they pay per... session?",
									goto = "porn"
								},
								
								{
									response = "Hmm... Never heard about that one. What kind of movies do you make there?",
									segue = "So what kind of movies do you prefer to work on?",
									id = "movies",
									nodes = 
									{
										{ 
											rule = {"#porn", "sexy", "love", "modelling", "lesbian", "anal", "bondage",
													"blowjob", "hardcore", "xxx", "milf", "erotica", "paizuri", "gonzo"},
											response = "Just porn? That's not the kind of acting I meant, but I... well, some famous actors started there. What's the wage per... scene?",
											segue = "How much do you pay for each.. you know... performance?", 
											id = "porn",
											msg = {"girl", {image = "level3"}},
											nodes = 
											{
												{ 
													rule = {"million", "[number=100000+=MONEY]"},
													response = {"Bullshit!\nGive me a real number!",
																"Not buying that.\nTell me the truth."},
													goto = "porn"
												},

												{ 
													rule = {"enough", "[number=500+=MONEY]", "lot", "alot", "ton", "big money", "good money",
														"nine hundred", "eight hundred", "seven hundred", "six hundred", "five hundred", 
														"thousand", "grand", "1k", "2k", "3k", "4k", "5k", "6k", "7k", "8k", "9k", "10k"},
														response = "If that's the case, then I think I can give it a try... I'll wait for your call, but don't keep me waiting for too long, OK?",
														msg = {"girl", {image = "level4"}},
														nodes = 
														{
															{
																response = "What's your name?",
																msg = {"restart"},
																goto = "name"
															}
														}
												},

												{ 
													rule = "[number=MONEY]",
													response = {"[MONEY]?! No way.\nMake me a better offer.",
																"Don't be so cheap, [NAME].\nI'm not that desperate.",
																"[MONEY] isn't enough. Can't you go higher?"},
													goto = "porn"
												},
												
												{ 
													rule = {"#yes", "how much"},
													response = "Make me a serious offer.",
													goto = "porn"
												},
												
												{ 
													response = {"Are you kidding me?",
																"How stupid do you think I am? Give me a better offer.",
																"Either give me a real salary fee or I'll walk.",
																"Stop wasting my time."},

													goto = "porn"
												}
											}
										},
										
										{ 
											rule = "action",
											response = "I'm not fit for high-action scenes. Do they shoot other kinds?",
											goto = "movies"
										},
										
										{ 
											rule = {"comedy", "comedies"},
											response = "I don't want my big break to be looking like an idiot. Don't you have a different movie for me to work in?",
											goto = "movies"
										},
										
										{ 
											rule = {"arthouse", "art house" },
											response = "Art isn't my thing. Too abstract. Got anything else I can work in?",
											goto = "movies"
										},
										
										{ 
											rule = {"drama", "melodrama"},
											response = "If I have to admit, I never got a degree in acting. So those kinds of movies would be difficult. Do you have something easier?",
											goto = "movies"
										},
										
										{ 
											rule = {"horror", "war"},
											response = "Ugh... no way. Women in horror films always get killed or messed up. I need to work in something I can show off my body with.",
											goto = "movies"
										},

										{ 
											rule = "romance",
											response = "Romances bore me. Though I do get a little heated when they get passionate. Any films like that in production?",
											goto = "movies"
										},

										{ 
											rule = "thriller",
											response = "Thrillers are so last year. I need something that lets me show off how sexy my body is. You can think of a something like that for me to work in, can't you?",
											goto = "movies"
										},
										
										{ 
											rule = "western",
											response = "A Western!? Those died out decades ago. Anything is better than that.",
											goto = "movies"
										},
										
										{ 
											rule = "kids",
											response = "I can't stand kids, let alone their movies. Give me something meant for adults.",
											goto = "movies"
										},
										
										{ 
											rule = {"sci-fi", "scifi", "Sci-Fi"},
											response = "No thanks. A friend told me you have to study for roles like that. I want something I can do now.",
											goto = "movies"
										},
										
										{ 
											rule = {"fantasy", "fiction"},
											response = "And work with CGI? No thank you. I work better with actual people. Like a sexy guy or something.",
											goto = "movies"
										},

										{ 
											rule = {"detective", "crime"},
											response = "Detective films and crime dramas are too depressing. Can't you give me something more exciting to work on?",
											goto = "movies"
										},
										
										{ 
											rule = {"cartoon", "animated", "toon"},
											response = "My voice is amazing, but I want people to see me and not some cartoon. You can think of something real, can't you?",
											goto = "movies"
										},

										{ 
											rule = "what skill",
											response = "I just want to show the world how hot I look. Simple and easy. There's got to be work for a woman like me, right?",
											goto = "movies"
										},
										
										{ 
											response = {"I didn't hear that right. Say again what kind of movies you make?",
														"Speak up. I can't hear what you're saying if you mumble.",
														"No. That doesn't suit my skills as an actor. What about some other genre?",
														"Not so sure about that. What else you got?",
														"What kind of movies do you make? Action? Comedy? Romance?"},
											goto = "movies"
										}
									}
								}
							}
						},
						{ 
							rule = "#no",
							response = {"But why not? I can do anything you need me to! Please..?",
										"Say yes. I can make it worth your time.",
										"Please, help me out? I promise you won't regret it"},
							goto = "help"
						},
						{ 
							rule = {"#must do", "#must become", "depends"},
							response = "I'll do whatever you want! I promise! Deal?",
							goto = "help"
						},

						{ 
							rule = {"what do", "if you"},
							response = "I can do anything you want me to! I swear it!",
							goto = "help"
						},

						{
							rule = "what role",
							response = "Mmm... maybe something that will let me show off my body. I don't mind tight clothes. Tell me the studio you work for again and I'll try to explain it better.",
							goto = "studio"
						},
						
						{
							response = "Be straight with me.\nCan you help me or not?",
							goto = "help"
						}
					}
				},

				{ 
					rule = {"me too", "mee too", "same"},
					response = "Reall? Then can you help me get a role?",
					goto = "help"
				},

				{ 
					rule = {"nothing", "unemployed", "student"},
					response = "You wouldn't be here if that was the case. Only men who work in films and movies hang around here.",
					goto = "occupation"
				},

				{ 
					rule = "fucker",
					response = "... Ugh, get lost, Loser. I'm only interested in men who act professional, like a producer.",
					goto = "occupation"
				},

				{ 
					rule = "web developer",
					response = "This game was created by a web developer. So let's get meta. I'm waiting for producer here.",
					goto = "occupation"
				},


				{ 
					rule = {"business", "businessman"},
					response = "Business? Like in the movie business? You work for a studio, don't you?",
					goto = "occupation"
				},
				
				{ 
					rule = {"pizza", "cook"},
					response = "If you work in the kitchen then bring me margarita and shove off. I'm waiting for a producer to come by.",
					goto = "occupation"
				},

				{ 
					rule = "king",
					response = "Oh please. The only king here is the guy calling the shots on the set. You're an extra at best.",
					goto = "occupation"
				},

				{ 
					rule = "looking for",
					response = "Well, let me know if you find something in the film industry. Connections are everything.",
					goto = "occupation"
				},

				{ 
					rule = "cesspool cleaner",
					response = "Egh! Get away from me!",
					goto = "occupation"
				},

				{ 
					rule = {"chick", "girl"},
					response = "You don't look like a woman to me.",
					goto = "occupation"
				},

				{ 
					rule = {"ok", "sure"},
					response = "If you can't give me an answer then go away.",
					goto = "occupation"
				},
				
				{
					response =  {"You're joking, right? Come on, what do you really do here in Hollywood?",
								"Really? I thought you were a producer of some kind. You look the part.",
								"That can't be right. I was sure this bar is only for people in the film industry and movies.",
								"That's a shame... I hoped you worked for some kind of movie studio.",
								"Tell me if you find a producer then and send him my way."},
					goto = "occupation"
				}
			}
		},
		
		--fallback
		{
			response = "Don't be shy. Tell me your name.",
			goto = "name"
		},
		
		--interjections
		{ 
			rule = "where you from",
			response = "Nebraska.",
			interjection = true
		},
		
		{ 
			rule = "sex",
			response = "Get serious.",
			interjection = true
		},
		{ 
			rule = {"i love you", "kiss me"},
			response = "Sorry, I... have a boyfriend.",
			interjection = true
		},
		{ 
			rule = "bot",
			response = "A bot?! No, I'm real.",
			interjection = true
		}
		
	}
}