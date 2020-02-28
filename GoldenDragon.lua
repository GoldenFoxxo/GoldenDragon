local discordia = require('discordia')
local timer = require('timer')
local uv = require('uv')
local ffi = require('ffi')
local clib = ffi.load('opus')
local clib = ffi.load('sodium')
local prefix = 'g!'
local atitle = "Nil"
local permscreen = false
local http = require('coro-http')
local sandbox = {}
local sw = discordia.Stopwatch()
local answ = {'What are you doing?','Checking out my new command eh?','What is this...','Hello Worl- wait why are you stalking me?','Pretty sure hes trying to do something.'}
local loopaudio = false
local ts = tostring
local cpu = uv.cpu_info()
local threads = #cpu
local cpumodel = cpu[1].model
local mem = math.floor(collectgarbage('count')/1000)
discordia.extensions()

sw:start()

local client = discordia.Client {
	logFile = 'mybot.log',
	cacheAllMembers = true,
}

local shouldUpdateGuildsCount = true

client:on('ready', function()
	print('Logged in as '.. client.user.username)
	while true do
		if shouldUpdateGuildsCount then
			client:setGame(prefix..'help | '..#client.guilds..' Guilds')
			shouldUpdateGuildsCount = false
		end
		timer.sleep(1000)
	end
end)

client:on('guildCreate', function(gj)
  	shouldUpdateGuildsCount = true
  	client:getGuild('425655510415572993'):getChannel('683049572221714485'):send{
	  	embed = {
			title = 'Join',
			thumbnail = {url = gj.iconURL},
			fields = {
				{name = 'Name', value = gj.name..'\n'..gj.id, inline = true},
				{name = 'Owner', value = gj.owner.name..'\n'..gj.owner.id, inline = true},
				{name = 'Membercount', value = gj.totalMemberCount, inline = true}
			},
			color = discordia.Color.fromRGB(255, 215, 0).value,
			timestamp = discordia.Date():toISO('T', 'Z')
		}
	}
end)

client:on('guildDelete', function(gl)
  	shouldUpdateGuildsCount = true
  	client:getGuild('425655510415572993'):getChannel('683049572221714485'):send{
		embed = {
			title = 'Leave',
	  		thumbnail = {url = gl.iconURL},
	  		fields = {
		  		{name = 'Name', value = gl.name..'\n'..gl.id, inline = true},
		  		{name = 'Owner', value = gl.owner.name..'\n'..gl.owner.id, inline = true},
		  		{name = 'Membercount', value = gl.totalMemberCount, inline = true}
	  		},
	  		color = discordia.Color.fromRGB(255, 215, 0).value,
	  		timestamp = discordia.Date():toISO('T', 'Z')
		}
	}
end)

client:on('messageCreate', function(message)

	if message.author.bot == false then
		if not message.guild then
			return
		else

			local guild = message.guild
			local args = message.content:split(' ')
			local member = message.member
			local logc = '434836657506746378'
			
			local function deleteself()
				message.channel:bulkDelete(message.channel:getMessages(1))
			end
			
			if message.content == prefix..'help' then
				client:getChannel(logc):send{
					embed = {
						title = 'Commands Used',
						fields = {
							{name = 'Information', value = '```User: '..message.author.name..'\nGuild: '..message.guild.name..'\nChannel: '..message.channel.name..'\nCommand: '..args[1]..'```', inline = false},
							{name = 'Full Information', value = '```'..message.content..'```', inline = false}
						},
						color = discordia.Color.fromRGB(255, 215, 0).value,
						timestamp = discordia.Date():toISO('T', 'Z')
					}
				}
				message.author:send {
					embed = {
						title = 'Heres the list of commands. The prefix is `'..prefix..'`',
						fields = {
							{name = 'ping', value = 'Just a response testing.', inline = false},
							{name = 'play', value = 'Plays a audio file from youtube. *In development (disabled)*', inline = false},
							{name = 'stopaudio', value = 'Stops the audio. *In development (disabled)*', inline = false},
							{name = 'pause', value = 'Pauses the audio stream. *In development (disabled)*', inline = false},
							{name = 'loopaudio', value = 'Loops the audio. *In development (disabled)*', inline = false},
							{name = 'np', value = 'Gives you info on what audio your listening now. *In development (disabled)*', inline = false},
							{name = 'systeminfo', value = 'Gives you a list of information of system that bot is being hosted on.', inline = false},
							{name = 'hackban', value = 'Bans offline user by using ID only.', inline = false},
							{name = 'time', value = 'Tells you about date and time.', inline = false},
							{name = 'screenshot', value = 'grabs screenshot from server.', inline = false},
							{name = 'say', value = 'Makes bot say what you said.', inline = false},
							{name = 'ban', value = 'Bans users. Reason and time not included, mentions required.', inline = false},
							{name = 'unban', value = 'Unbans users. ID required to unban.', inline = false},
							{name = '8ball', value = 'Magic 8 ball and it answers your burning questions.', inline = false},
							{name = 'stop', value = 'Stops or disables the bot. *Bot owner command only!*', inline = false},
							{name = 'restart', value = 'Restarts the bot. *Bot owner command only!*', inline = false},
							{name = 'hump', value = 'Humps the user.', inline = false},
							{name = 'spray', value = 'Sprays the user.', inline = false},
							{name = 'fur', value = 'Determines the furry level about yourself.', inline = false},
							{name = 'changelog', value = 'Shows you information and version what updated about this bot.', inline = false},
							{name = 'purge', value = 'Deletes amount of messages given.', inline = false},
							{name = 'hug', value = 'Hug someone!', inline = false},
							{name = 'info', value = 'Tells you information about this bot.', inline = false},
							{name = 'uptime', value = 'Uptime for this bot.', inline = false}
						},
						color = discordia.Color.fromRGB(255, 215, 0).value,
						timestamp = discordia.Date():toISO('T', 'Z')
					}
				}
			end

			if message.content == prefix..'changelog' then
				client:getChannel(logc):send{
					embed = {
						title = 'Commands Used',
						fields = {
							{name = 'Information', value = '```User: '..message.author.name..'\nGuild: '..message.guild.name..'\nChannel: '..message.channel.name..'\nCommand: '..args[1]..'```', inline = false},
							{name = 'Full Information', value = '```'..message.content..'```', inline = false}
						},
						color = discordia.Color.fromRGB(255, 215, 0).value,
						timestamp = discordia.Date():toISO('T', 'Z')
					}
				}
				return message.channel:send {
					content = '**GoldenDragon v1.4**\n+added fur command\n+added music function (Still experimental/disabled)\n+added guild log code\n+added systeminfo command\n+added hump command\n+added spray command\n*modified some code'
				}
			end

			if message.content == prefix..'systeminfo' then
				client:getChannel(logc):send{
					embed = {
						title = 'Commands Used',
						fields = {
							{name = 'Information', value = '```User: '..message.author.name..'\nGuild: '..message.guild.name..'\nChannel: '..message.channel.name..'\nCommand: '..args[1]..'```', inline = false},
							{name = 'Full Information', value = '```'..message.content..'```', inline = false}
						},
						color = discordia.Color.fromRGB(255, 215, 0).value,
						timestamp = discordia.Date():toISO('T', 'Z')
					}
				}
				fmem = uv:get_free_memory()
				tmem = uv:get_total_memory()
				function round(t)
    				return math.round(t*10)*0.1
				end
				umem = tmem - fmem
				message.channel:send{
					embed = {
						fields = {
							{name = 'System Info', value = '**CPU**\nOS: '..ts(ffi.os)..'\nCPU Threads: '..ts(threads)..'\nCPU Model: '..ts(cpumodel)..'\nSystem Uptime: '..ts(discordia.Time.fromSeconds(uv.uptime()))..'\n**Memory**\nTotal: '..round(tmem/1073741824)..'GB\nFree: '..round(fmem/1073741824)..'GB\nUsed: '..round(umem/1073741824)..'GB'}
						},
						color = discordia.Color.fromRGB(255, 215, 0).value,
						timestamp = discordia.Date():toISO('T', 'Z')
					}
				}
			end

			--if args[1] == prefix..'loopaudio' then
				--if loopaudio == true then
					--loopaudio = false
					--return message.channel:send('Audio loop has been disabled!')
				--elseif loopaudio == false then
					--loopaudio = true
					--return message.channel:send('Audio loop has been enabled!')
				--end
			--end

			--if args[1] == prefix..'play' then
				--if not args[2] then
					--return message.channel:send('Incomplete command.')
				--else
					--if string.match(args[2], 'https://www.youtube.com/.-') ~= nil then
						--for vchan in message.guild.voiceChannels:iter() do
							--for vmem in vchan.connectedMembers:iter() do
								--if message.author.id == vmem.id then
									--uchek = false
									--ytaud = io.open('run.bat','w')
									--ytaud:write('@echo off\nyoutube-dl --config-location youtube-dl.conf '..args[2])
									--ytaud:close()
									--message.channel:send('Requesting data...')
									--os.execute('run.bat')
									--audiodata = io.open('audiostream.info.json', 'r')
									--adata = audiodata:read('*a')
									--audiodata:close()
									--radata = adata:split(',')
									--for a = 1, #radata do
										--if string.match(radata[a], '"title".-') ~= nil then
											--paud = radata[a]
										--end
										--if string.match(radata[a], '"webpage_url".-') ~= nil then
											--pdaud = radata[a]
										--end
									--end
									--atitle = table.concat(paud:split(':')[2]:split('"'), ' ')
									--adescription = pdaud:split('"webpage_url":')[2]:split('"')[2]
									--message.channel:send('Request complete, joining...')
									--timer.sleep(2000)
									--local channel = client:getChannel(vchan.id)
									--local connection = channel:join()
									--coroutine.wrap(function()
										--if loopaudio == false then
											--connection:playFFmpeg('audiostream.mp3')
										--end
										--while loopaudio == true do
											--connection:playFFmpeg('audiostream.mp3')
										--end
										--message.channel:send('Done streaming.')
							  		--end)()
								--message.channel:send('Starting audio stream.')
								--end
							--end
						--end
					--else
						--return message.channel:send('Invalid YouTube link, please use full YouTube link.')
					--end
				--end
			--end

			--if message.content == prefix..'stopaudio' then
				--message.channel:send('Stopping audio stream.')
				--if loopaudio == true then
					--loopaudio = false
					--message.guild.connection:stopStream()
					--loopaudio = true
				--else
					--return message.guild.connection:stopStream()
				--end
			--end

			--if message.content == prefix..'pause' then
				--message.channel:send('Pausing audio stream.')
				--return message.guild.connection:pauseStream()
			--end

			--if message.content == prefix..'resume' then
				--message.channel:send('Resuming audio stream.')
				--return message.guild.connection:resumeStream()
			--end

			--if message.content == prefix..'np' then
				--return message.channel:send{
					--embed = {
						--title = "Now Playing | Loop: "..tostring(loopaudio),
						--fields = {
							--{name = '**'..atitle..'**', value = adescription, inline = false}
						--},
						--color = discordia.Color.fromRGB(255, 215, 0).value,
						--timestamp = discordia.Date():toISO('T', 'Z')
					--}
				--}
			--end
			
			--if message.content == prefix..'prefix' then
				--if message.member:hasPermission(8) == true then
					--if not args[2] then
						--return message.channel:send('Incomplete command.')
					--else
						--pconf = io.open("config.txt", "w")
						--pconf:write("{'"..message.guild.id.."','"..args[2].."'}")
						--pconf:close()
						--return message.channel:send("Prefix saved as `"..args[2].."`")
					--end
				--else
					--return message.channel:send('You do not have enough permissions to perform this command.')
				--end
			--end

			if message.content == prefix..'permscreenshot' and message.author.id == client.owner.id then
				if permscreen == true then
					permscreen = false
					return message.channel:send('The '..prefix..'screenshot command has been disabled.')
				elseif permscreen == false then
					permscreen = true
					return message.channel:send('The '..prefix..'screenshot command has been enabled.')
				end
			end

			if message.content == prefix..'screenshot' then
				if permscreen == true then
					client:getChannel(logc):send{
						embed = {
							title = 'Commands Used',
							fields = {
								{name = 'Information', value = '```User: '..message.author.name..'\nGuild: '..message.guild.name..'\nChannel: '..message.channel.name..'\nCommand: '..args[1]..'```', inline = false},
								{name = 'Full Information', value = '```'..message.content..'```', inline = false}
							},
							color = discordia.Color.fromRGB(255, 215, 0).value,
							timestamp = discordia.Date():toISO('T', 'Z')
						}
					}
					message.channel:broadcastTyping()
					os.execute('screenshot.bat')
					timer.sleep(5000)
					cho = math.random(0,#answ)
					return message.channel:send{
						file = 'screenshot.png',
						embed = {
							fields = {
								{name = 'Screenshot taken.', value = answ[cho], inline = false}
							},
							color = discordia.Color.fromRGB(255,215,0).value
						}
					}
				elseif permscreen == false then
					return message.channel:send('Access to '..prefix..'screenshot command has been disabled.')
				end
			end

			if args[1] == prefix..'hump' then 
				if not args[2] then
					return message.channel:send('Incomplete Command.')
				else
					if message.channel.nsfw == true then
						client:getChannel(logc):send{
							embed = {
								title = 'Commands Used',
								fields = {
									{name = 'Information', value = '```User: '..message.author.name..'\nGuild: '..message.guild.name..'\nChannel: '..message.channel.name..'\nCommand: '..args[1]..'```', inline = false},
									{name = 'Full Information', value = '```'..message.content..'```', inline = false}
								},
								color = discordia.Color.fromRGB(255, 215, 0).value,
								timestamp = discordia.Date():toISO('T', 'Z')
							}
						}
						hrand = math.random(1, 5)
						if hrand == 1 then
							return message.channel:send('**'..message.author.name..'** grinds their loins furiously against **'..args[2]..'**. Oh my! <:monkas:665696521488171058>')
						elseif hrand == 2 then
							return message.channel:send('A valiant hero **'..message.author.name..'** appears, dismounts their mighty steed in front of **'..args[2]..'** and thrusts their hips forward. The rest of the story remined hidden in history.')
						elseif hrand == 3 then
							return message.channel:send('**'..args[2]..'** could run but couldn`t hide from **'..message.author.name..'**, thus got humped thoroughly.')
						elseif hrand == 4 then
							return message.channel:send('Loud noises attract everyone`s attention. Look! **'..message.author.name..'** humps **'..args[2]..'**!')
						elseif hrand == 5 then
							return message.channel:send('Did **'..message.author.name..'** drink one too many? **'..args[2]..'** sure thinks so, this arm humping is getting out of hand!')
						end
					else
						return message.channel:send('Error: Channel not marked nsfw.')
					end
				end
			end

			if args[1] == prefix..'spray' then 
				if not args[2] then
					return message.channel:send('Incomplete Command.')
				else
					client:getChannel(logc):send{
						embed = {
							title = 'Commands Used',
							fields = {
								{name = 'Information', value = '```User: '..message.author.name..'\nGuild: '..message.guild.name..'\nChannel: '..message.channel.name..'\nCommand: '..args[1]..'```', inline = false},
								{name = 'Full Information', value = '```'..message.content..'```', inline = false}
							},
							color = discordia.Color.fromRGB(255, 215, 0).value,
							timestamp = discordia.Date():toISO('T', 'Z')
						}
					}
					srand = math.random(1, 5)
					if srand == 1 then
						return message.channel:send('**'..message.author.name..'** empties a whole spray bottle in **'..args[2]..'`s** face; one furious spray at a time.')
					elseif srand == 2 then
						return message.channel:send('**'..message.author.name..'** squirts all over **'..args[2]..'** to make them stop. Mmm, kinky.')
					elseif srand == 3 then
						return message.channel:send('**'..message.author.name..'** is not amused and sprayspraysprays **'..args[2]..'** until there was not a single fur dry!')
					elseif srand == 4 then
						return message.channel:send('Guess we know who sleeps in the dog house tonight. **'..args[2]..'** got sprayed at by one and only **'..message.author.name..'**!')
					elseif srand == 5 then
						return message.channel:send('**'..args[2]..'** yiffed at the wrong person and got sprayed at by **'..message.author.name..'**.')
					end
				end
			end
			
			if message.content == prefix..'info' then
				client:getChannel(logc):send{
					embed = {
						title = 'Commands Used',
						fields = {
							{name = 'Information', value = '```User: '..message.author.name..'\nGuild: '..message.guild.name..'\nChannel: '..message.channel.name..'\nCommand: '..args[1]..'```', inline = false},
							{name = 'Full Information', value = '```'..message.content..'```', inline = false}
						},
						color = discordia.Color.fromRGB(255, 215, 0).value,
						timestamp = discordia.Date():toISO('T', 'Z')
					}
				}
				out = 0
				for guild in client.guilds:iter() do
					out = out + guild.totalMemberCount
				end
				gldbot = message.guild:getMember('369244923574091790')
				return message.channel:send{
					embed = {
						title = '**GoldenDragon Dev**',
						thumbnail = {url = gldbot.avatarURL},
						description = '**Bot Version**\nV1.4\n**Library**\nDiscordia\n**Lib Version**\n'.._VERSION..'\n**Information**\nThis bot was created and hosted by MLG Golden.\nAnd also has few commands which includes moderation, fun, and soon-to-be community idea given that can be implemented into this bot.\n**Guilds**\n'..#client.guilds..'\n**Members**\n'..out..'\n**Support**\nhttps://discord.gg/G9NcUTE',
						color = discordia.Color.fromRGB(255, 215, 0).value,
						timestamp = discordia.Date():toISO('T', 'Z')
					}
				}
			end

			if message.content == prefix..'stop' then
				client:getChannel(logc):send{
					embed = {
						title = 'Commands Used',
						fields = {
							{name = 'Information', value = '```User: '..message.author.name..'\nGuild: '..message.guild.name..'\nChannel: '..message.channel.name..'\nCommand: '..args[1]..'```', inline = false},
							{name = 'Full Information', value = '```'..message.content..'```', inline = false}
						},
						color = discordia.Color.fromRGB(255, 215, 0).value,
						timestamp = discordia.Date():toISO('T', 'Z')
					}
				}
				if message.author.id == '201443773077520384' then
					message.channel:send('Stopping...')
					client:stop()
				else
					message.channel:send('Only bot owner is allowed to use this command!')
				end
			end

			if message.content == prefix..'restart' then
				client:getChannel(logc):send{
					embed = {
						title = 'Commands Used',
						fields = {
							{name = 'Information', value = '```User: '..message.author.name..'\nGuild: '..message.guild.name..'\nChannel: '..message.channel.name..'\nCommand: '..args[1]..'```', inline = false},
							{name = 'Full Information', value = '```'..message.content..'```', inline = false}
						},
						color = discordia.Color.fromRGB(255, 215, 0).value,
						timestamp = discordia.Date():toISO('T', 'Z')
					}
				}
				if message.author.id == '201443773077520384' then
					message.channel:send('Restarting...')
					client:stop()
					os.execute('start.bat')
				else
					message.channel:send('Only bot owner is allowed to use this command!')
				end
			end

			if message.content == prefix..'fur' then
				fur = {' is borderline furry.',' is dangerously furry.',' is not a furry.',' is a human.'}
				return message.channel:send{
					embed = {
						description = '<@'..message.author.id..'> '..fur[math.random(1,#fur)],
						color = discordia.Color.fromRGB(255, 215, 0).value
					}
				}
			end

			if message.content == prefix..'time' then
				client:getChannel(logc):send{
					embed = {
						title = 'Commands Used',
						fields = {
							{name = 'Information', value = '```User: '..message.author.name..'\nGuild: '..message.guild.name..'\nChannel: '..message.channel.name..'\nCommand: '..args[1]..'```', inline = false},
							{name = 'Full Information', value = '```'..message.content..'```', inline = false}
						},
						color = discordia.Color.fromRGB(255, 215, 0).value,
						timestamp = discordia.Date():toISO('T', 'Z')
					}
				}
				message.channel:send('**'..os.date()..'**')
			end

			if args[1] == prefix..'ban' then
				client:getChannel(logc):send{
					embed = {
						title = 'Commands Used',
						fields = {
							{name = 'Information', value = '```User: '..message.author.name..'\nGuild: '..message.guild.name..'\nChannel: '..message.channel.name..'\nCommand: '..args[1]..'```', inline = false},
							{name = 'Full Information', value = '```'..message.content..'```', inline = false}
						},
						color = discordia.Color.fromRGB(255, 215, 0).value,
						timestamp = discordia.Date():toISO('T', 'Z')
					}
				}
				if not args[2] then
					return message.channel:send('Incomplete command.')
				else
					if message.member:hasPermission(8) == true or message.author.id == client.owner.id then
						message.guild:banUser(message.mentionedUsers:iter()())
						return message.channel:send('**'..args[2]..' banned!**')
					else
						return message.channel:send('You do not have enough permissions to perform this command.')
					end
				end
			end
			
			if args[1] == prefix..'hackban' then
				client:getChannel(logc):send{
					embed = {
						title = 'Commands Used',
						fields = {
							{name = 'Information', value = '```User: '..message.author.name..'\nGuild: '..message.guild.name..'\nChannel: '..message.channel.name..'\nCommand: '..args[1]..'```', inline = false},
							{name = 'Full Information', value = '```'..message.content..'```', inline = false}
							
						},
						color = discordia.Color.fromRGB(255, 215, 0).value,
						timestamp = discordia.Date():toISO('T', 'Z')
					}
				}
				if not args[2] then
					return message.channel:send('Incomplete command.')
				else
					if message.member:hasPermission(8) == true or message.author.id == client.owner.id then
						message.guild:banUser(args[2])
						return message.channel:send('**'..args[2]..' successfully hackbanned!**')
					else
						return message.channel:send('You do not have enough permissions to perform this command.')
					end
				end
			end

			if args[1] == prefix..'unban' then
				client:getChannel(logc):send{
					embed = {
						title = 'Commands Used',
						fields = {
							{name = 'Information', value = '```User: '..message.author.name..'\nGuild: '..message.guild.name..'\nChannel: '..message.channel.name..'\nCommand: '..args[1]..'```', inline = false},
							{name = 'Full Information', value = '```'..message.content..'```', inline = false}
						},
						color = discordia.Color.fromRGB(255, 215, 0).value,
						timestamp = discordia.Date():toISO('T', 'Z')
					}
				}
				if not args[2] then
					return message.channel:send('Incomplete command.')
				else
					if message.member:hasPermission(8) == true or message.author.id == client.owner.id then
						message.guild:unbanUser(args[2])
						return message.channel:send('**'..args[2]..' unbanned!**')
					else
						return message.channel:send('You do not have enough permissions to perform this command.')
					end
				end
			end

			if args[1] == prefix..'say' then 
				client:getChannel(logc):send{
					embed = {
						title = 'Commands Used',
						fields = {
							{name = 'Information', value = '```User: '..message.author.name..'\nGuild: '..message.guild.name..'\nChannel: '..message.channel.name..'\nCommand: '..args[1]..'```', inline = false},
							{name = 'Full Information', value = '```'..message.content..'```', inline = false}
						},
						color = discordia.Color.fromRGB(255, 215, 0).value,
						timestamp = discordia.Date():toISO('T', 'Z')
					}
				}
				table.remove(args,1)
				message.channel:send(table.concat(args,' '))
			end

			if args[1] == prefix..'ping' then
				client:getChannel(logc):send{
					embed = {
						title = 'Commands Used',
						fields = {
							{name = 'Information', value = '```User: '..message.author.name..'\nGuild: '..message.guild.name..'\nChannel: '..message.channel.name..'\nCommand: '..args[1]..'```', inline = false},
							{name = 'Full Information', value = '```'..message.content..'```', inline = false}
						},
						color = discordia.Color.fromRGB(255, 215, 0).value,
						timestamp = discordia.Date():toISO('T', 'Z')
					}
				}
				local response = message:reply('Pong!')
				if response then
					response:setContent('Pong! '..'`'..math.abs(math.round((response.createdAt - message.createdAt)*1000))..' ms`')
				end
			end

			if args[1] == prefix..'hug' then 
				if not args[2] then
					return message.channel:send('Incomplete Command.')
				else
					client:getChannel(logc):send{
						embed = {
							title = 'Commands Used',
							fields = {
								{name = 'Information', value = '```User: '..message.author.name..'\nGuild: '..message.guild.name..'\nChannel: '..message.channel.name..'\nCommand: '..args[1]..'```', inline = false},
								{name = 'Full Information', value = '```'..message.content..'```', inline = false}
							},
							color = discordia.Color.fromRGB(255, 215, 0).value,
							timestamp = discordia.Date():toISO('T', 'Z')
						}
					}
					table.remove(args,1)
					message.channel:send{
						mentions = {message.author},
						content = 'hugged '..table.concat(args,' ')..'.',
					}
				end
			end

			if args[1] == prefix..'8ball' then
				client:getChannel(logc):send{
					embed = {
						title = 'Commands Used',
						fields = {
							{name = 'Information', value = '```User: '..message.author.name..'\nGuild: '..message.guild.name..'\nChannel: '..message.channel.name..'\nCommand: '..args[1]..'```', inline = false},
							{name = 'Full Information', value = '```'..message.content..'```', inline = false}
						},
						color = discordia.Color.fromRGB(255, 215, 0).value,
						timestamp = discordia.Date():toISO('T', 'Z')
					}
				}
				if not args[2] then
					return message.channel:send('You did not state the question.')
				else
					ballc = {'Yes.','No.','My thoughts says no.','My thoughts says yes.','Probably, probably not.','Yes, absolutely.','No, definitely not.','My reply is no.','My reply is yes.','maybe.'}
					message.channel:send{
						mentions = {message.author},
						content = ballc[math.random(1,#ballc)],
					}
				end
			end

			if args[1] == prefix..'uptime' then
				client:getChannel(logc):send{
					embed = {
						title = 'Commands Used',
						fields = {
							{name = 'Information', value = '```User: '..message.author.name..'\nGuild: '..message.guild.name..'\nChannel: '..message.channel.name..'\nCommand: '..args[1]..'```', inline = false},
							{name = 'Full Information', value = '```'..message.content..'```', inline = false}
						},
						color = discordia.Color.fromRGB(255, 215, 0).value,
						timestamp = discordia.Date():toISO('T', 'Z')
					}
				}
				return message.channel:send('**Bot Uptime**\n'..tostring(sw:getTime())..'\n**System Uptime**\n'..tostring(discordia.Time.fromSeconds(uv.uptime())))
			end

			if args[1] == prefix..'purge' then
				if not args[2] then
					return message.channel:send('Incomplete Command.')
				else
					client:getChannel(logc):send{
						embed = {
							title = 'Commands Used',
							fields = {
								{name = 'Information', value = '```User: '..message.author.name..'\nGuild: '..message.guild.name..'\nChannel: '..message.channel.name..'\nCommand: '..args[1]..'```', inline = false},
								{name = 'Full Information', value = '```'..message.content..'```', inline = false}
							},
							color = discordia.Color.fromRGB(255, 215, 0).value,
							timestamp = discordia.Date():toISO('T', 'Z')
						}
					}
					if message.member:hasPermission(8) == true or message.author.id == client.owner.id then
						if tonumber(args[2]) then
							timer.sleep(100)
							message.channel:bulkDelete(message.channel:getMessages(args[2]+1))
							timer.sleep(100)
							message.channel:send('Purged '..args[2]..' Messages.')
							timer.sleep(3000)
							return deleteself()
						else
							return message.channel:send('Please use number value.')
						end
					else
						message.channel:send('You do not have enough permissions to perform this command.')
					end
				end
			end

			sandbox.require = require
			sandbox.client = client
			sandbox.http = http
			sandbox.guild = guild
			sandbox.timer = timer
			sandbox.discordia = discordia
			sandbox.uv = uv
			sandbox.sw = sw
			sandbox.ffi = ffi
			sandbox.clib = clib
			sandbox.print = function(...)
				message.channel:send(...)
			end
			sandbox = setmetatable(sandbox, { __index = _G })

			local function code(str)
				message.channel:send(string.format('```\n%s```', str))
			end

			local function exec(arg)
				if not arg then return end
				sandbox.message = message
				local fn, syntaxError = load(arg, 'GoldenDragon Dev', 't', sandbox)
				if not fn then return code(syntaxError) end
				local success, runtimeError = pcall(fn)
				if not success then
					code(runtimeError)
				else
					if not runtimeError then
					else
						message.channel:send{
							embed = {
								title = "Eval",
								fields = {
									{name = 'Input', value = '```lua\n'..table.concat(args, ' ')..'```', inline = false},
									{name = 'Output', value = '```'..runtimeError..'```', inline = false}
								},
								color = discordia.Color.fromRGB(255, 215, 0).value,
								timestamp = discordia.Date():toISO('T', 'Z')
							}
						}
					end
				end
			end

			if args[1] == prefix..'eval' then
				client:getChannel(logc):send{
					embed = {
						title = 'Commands Used',
						fields = {
							{name = 'Information', value = '```User: '..message.author.name..'\nGuild: '..message.guild.name..'\nChannel: '..message.channel.name..'\nCommand: '..args[1]..'```', inline = false},
							{name = 'Full Information', value = '```'..message.content..'```', inline = false}
						},
						color = discordia.Color.fromRGB(255, 215, 0).value,
						timestamp = discordia.Date():toISO('T', 'Z')
					}
				}
				if not args[2] then
					return message.channel:send('Incomplete Command!')
				else
					if message.author.id == client.owner.id then
						table.remove(args,1)
						earg = table.concat(args,' ')
						exec(earg)
					else
						return message.channel:send('Bot Owner And Developers Only!')
					end
				end
			end
		end
	end
end)

local token = os.getenv('GoldenDragon_Token')

if not token then
  error("Please set the token to an environment variable called 'GoldenDragon_Token'")
end

client:run('Bot '..token)
