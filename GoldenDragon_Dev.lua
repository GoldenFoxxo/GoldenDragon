local discordia = require('discordia')
local timer = require('timer')
local uv = require('uv')
local ffi = require('ffi')
local clib = ffi.load('opus')
local clib = ffi.load('sodium')
local luatz = require('luatz')
local pp = require('pretty-print')
local http_headers = require('http.headers')
local prefix = 'g?'
local atitle = "Nil"
local fs = require('fs')
local permscreen = false
local json = require('json')
local http = require('coro-http')
local sandbox = {}
local sw = discordia.Stopwatch()
local sw2 = discordia.Stopwatch()
local asw = discordia.Stopwatch()
local answ = {'What are you doing?','Checking out my new command eh?','What is this...','Hello Worl- wait why are you stalking me?','Pretty sure hes trying to do something.'}
local loopaudio = false
local ts = tostring
local cpu = uv.cpu_info()
local threads = #cpu
local cpumodel = cpu[1].model
local mem = math.floor(collectgarbage('count')/1000)
local dura = ''
local pts = 0
local ptm = 0
local pth = 0
local pdura = '0'
discordia.extensions()

sw:start()

local function prettyLine(...)
	print('pp success')
	local ret = {}
	for i = 1, select('#', ...) do
		table.insert(ret, pp.dump(select(i, ...), nil, true))
	end
	return table.concat(ret, '\t')
end

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

			conf = io.open('config.txt', 'r')
			config = json.decode(conf:read('*a'))
			conf:close()

			scanm = false
			for scanp = 1, #config.guilds.prefix do
				if message.guild.id == config.guilds.prefix[scanp] then
					scanm = true
					prefix = config.guilds.prefix[scanp+1]
				elseif scanp == #config.guilds.prefix and scanm == false then
					prefix = 'g?'
				end
			end
			
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
							{name = 'fa', value = 'Pulls image from fur affinity.', inline = false},
							{name = 'ban', value = 'Bans users. Reason and time not included, mentions required.', inline = false},
							{name = 'unban', value = 'Unbans users. ID required to unban.', inline = false},
							{name = '8ball', value = 'Magic 8 ball and it answers your burning questions.', inline = false},
							{name = 'stop', value = 'Stops or disables the bot. *Bot owner command only!*', inline = false},
							{name = 'restart', value = 'Restarts the bot. *Bot owner command only!*', inline = false},
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
					content = '**GoldenDragon Dev v1.6**\n+added music function (Still experimental/disabled)\n+added guild log code\n+added systeminfo command\n*modified some code'
				}
			end

			gban = message.content:split(' ')
    		if gban[1] == prefix..'globalban' and message.author.id == client.owner.id then
        		if not gban[2] then
            		return message.channel:send{
                		embed = {
                    	author = {name=message.author.name,icon_url=message.author.avatarURL},
                    		title = 'Command: '..prefix..'globalban',
                    		description = 'Description: Globally ban a member in any guild this bot lives in.\nUsage: '..prefix..'globalban [user] [reason]',
                    		color = discordia.Color.fromRGB(255, 215, 0).value,
                    		timestamp = discordia.Date():toISO('T', 'Z')
                		}
            		}
        		end
       			if tonumber(gban[2]) then
            		gid = gban[2]
        		else
            		return message.channel:send('Please use id to ban.')
        		end
        		if gban[3] then
            		table.remove(gban,1)
            		table.remove(gban,1)
            		greason = table.concat(gban, ' ')
        		else
            		greason = 'No reasons given.'
        		end
        		for guild in client.guilds:iter() do
            		guild:banUser(gid, greason)
        		end
        		return message.channel:send('Successfully performed a global ban on "'..gid..'" For reason: "'..greason..'"')
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
							{name = 'System Info', value = '**CPU**\nOS: '..ts(ffi.os)..'\nCPU Threads: '..ts(threads)..'\nCPU Model: '..ts(cpumodel)..'\nSystem Up'..string.lower(ts(discordia.Time.fromSeconds(uv.uptime())))..'\n**Memory**\nTotal: '..round(tmem/1073741824)..'GB\nFree: '..round(fmem/1073741824)..'GB\nUsed: '..round(umem/1073741824)..'GB'}
						},
						color = discordia.Color.fromRGB(255, 215, 0).value,
						timestamp = discordia.Date():toISO('T', 'Z')
					}
				}
			end

			if args[1] == prefix..'loopaudio' then
				if loopaudio == true then
					loopaudio = false
					return message.channel:send('Audio loop has been disabled!')
				elseif loopaudio == false then
					loopaudio = true
					return message.channel:send('Audio loop has been enabled!')
				end
			end

			if args[1] == prefix..'play' then
				if not args[2] then
					return message.channel:send('Incomplete command.')
				else
					if string.match(args[2], 'https://www.youtube.com/.-') ~= nil or string.match(args[2], 'https://m.youtube.com/.-') ~= nil then
						for vchan in message.guild.voiceChannels:iter() do
							for vmem in vchan.connectedMembers:iter() do
								if message.author.id == vmem.id then
									uchek = false
									ytaud = io.open('run.bat','w')
									ytaud:write('@echo off\nyoutube-dl --config-location youtube-dl.conf '..args[2])
									ytaud:close()
									message.channel:send('Requesting data...')
									os.execute('run.bat')
									audiodata = io.open('audiostream.info.json', 'r')
									adata = json.decode(audiodata:read('*a'))
									audiodata:close()
									atitle = adata.title
									adescription = adata.webpage_url
									athumb = adata.thumbnail
									outf = 0
									outm = math.floor(adata.duration/60)
									outh = math.floor(outm/60)
									if outm ~= 0 then
  										outf = 1
  										outrs = tostring(adata.duration-outm*60):split('')
									end
									if #outrs == 1 then
										outs = '0'..table.concat(outrs, '')
									else
										outs = table.concat(outrs, '')
									end
									if outh ~= 0 then
  										outf = 2
  										outm = outm-outh*60
									end
									if outf == 0 then
  										dura = '0:'..outs
									elseif outf == 1 then
  										dura = outm..':'..outs
									elseif outf == 2 then
  										dura = outh..':'..outm..':'..outs
									end
									message.channel:send('Request complete, joining...')
									asw:reset()
									timer.sleep(2000)
									local channel = client:getChannel(vchan.id)
									local connection = channel:join()
									coroutine.wrap(function()
										if loopaudio == false then
											asw:start()
											connection:playFFmpeg('audiostream.mp3')
										end
										while loopaudio == true do
											asw:reset()
											asw:start()
											connection:playFFmpeg('audiostream.mp3')
										end
										asw:stop()
										message.channel:send('Done streaming.')
							  		end)()
								message.channel:send('Starting audio stream.')
								end
							end
						end
					else
						ybody = {}
						videoId = {}
						ysl = 1
						table.remove(args, 1)
						sargs = table.concat(args, '+')
						res, body = http.request('GET', 'https://www.youtube.com/results?search_query='..sargs)
						ybody = body:split(':')
						for yt = 1, #ybody do
							if ybody[yt] == '[{"videoRenderer"' then
								videoId[ysl] = 'https://www.youtube.com/watch?v='..ybody[yt+2]:split('"')[2]
								ysl = ysl + 1
							end
						end
						message.channel:send('Now playing '..videoId[1])
						for vchan in message.guild.voiceChannels:iter() do
							for vmem in vchan.connectedMembers:iter() do
								if message.author.id == vmem.id then
									uchek = false
									ytaud = io.open('run.bat','w')
									ytaud:write('@echo off\nyoutube-dl --config-location youtube-dl.conf '..videoId[1])
									ytaud:close()
									message.channel:send('Requesting data...')
									os.execute('run.bat')
									audiodata = io.open('audiostream.info.json', 'r')
									adata = json.decode(audiodata:read('*a'))
									audiodata:close()
									atitle = adata.title
									adescription = adata.webpage_url
									athumb = adata.thumbnail
									outf = 0
									outm = math.floor(adata.duration/60)
									outh = math.floor(outm/60)
									if outm ~= 0 then
  										outf = 1
  										outrs = tostring(adata.duration-outm*60):split('')
									end
									if #outrs == 1 then
										outs = '0'..table.concat(outrs, '')
									else
										outs = table.concat(outrs, '')
									end
									if outh ~= 0 then
  										outf = 2
  										outm = outm-outh*60
									end
									if outf == 0 then
  										dura = '0:'..outs
									elseif outf == 1 then
  										dura = outm..':'..outs
									elseif outf == 2 then
  										dura = outh..':'..outm..':'..outs
									end
									message.channel:send('Request complete, joining...')
									asw:reset()
									timer.sleep(2000)
									local channel = client:getChannel(vchan.id)
									local connection = channel:join()
									coroutine.wrap(function()
										if loopaudio == false then
											asw:start()
											connection:playFFmpeg('audiostream.mp3')
										end
										while loopaudio == true do
											asw:reset()
											asw:start()
											connection:playFFmpeg('audiostream.mp3')
										end
										asw:stop()
										message.channel:send('Done streaming.')
							  		end)()
								message.channel:send('Starting audio stream.')
								end
							end
						end
					end
				end
			end

			if message.content == prefix..'stopaudio' then
				message.channel:send('Stopping audio stream.')
				asw:stop()
				if loopaudio == true then
					loopaudio = false
					message.guild.connection:stopStream()
					loopaudio = true
				else
					return message.guild.connection:stopStream()
				end
			end

			if message.content == prefix..'pause' then
				message.channel:send('Pausing audio stream.')
				asw:stop()
				return message.guild.connection:pauseStream()
			end

			if message.content == prefix..'resume' then
				message.channel:send('Resuming audio stream.')
				asw:start()
				return message.guild.connection:resumeStream()
			end

			if message.content == prefix..'np' then
				aplayt = tostring(asw:getTime()):split(' ')
				for as = 1, #aplayt do
					if string.match(aplayt[as], 'second,') ~= nil or string.match(aplayt[as], 'seconds,') ~= nil then
						ats = as - 1
						ptrs = tostring(aplayt[ats]):split('')
						if #ptrs == 1 then
							pts = '0'..table.concat(ptrs, '')
						else
							pts = table.concat(ptrs, '')
						end
					end
					if string.match(aplayt[as], 'minute,') ~= nil or string.match(aplayt[as], 'minutes,') ~= nil then
						ats = as - 1
						ptm = aplayt[ats]
					end
					if string.match(aplayt[as], 'hour,') ~= nil or string.match(aplayt[as], 'hours,') ~= nil then
						ats = as - 1
						pth = aplayt[ats]
					end
				end
				if pts == '0' then
					pts = '00'
				end
				if ptm == 0 and pth == 0 then
					pdura = '0:'..pts
				elseif pth == 0 then
					pdura = ptm..':'..pts
				elseif pth > 0 then
					pdura = pth..':'..ptm..':'..pts
				end
				message.channel:send{
					embed = {
						title = "Now Playing | Loop: "..tostring(loopaudio),
						thumbnail = {url = athumb},
						fields = {
							{name = '**'..atitle..'**', value = 'Link: '..adescription..'\nDuration: '..pdura..'/'..dura, inline = false}
						},
						color = discordia.Color.fromRGB(255, 215, 0).value,
						timestamp = discordia.Date():toISO('T', 'Z')
					}
				}
				pts = 0
				ptm = 0
				pth = 0
			end
			
			if message.content == prefix..'serverinfo' then
				ct = luatz.timetable.new_from_timestamp(message.guild.createdAt)
				message.channel:send{
					embed = {
						title = 'Server Info',
						thumbnail = {url = message.guild.iconURL},
						fields = {
							{name = 'Name:', value = message.guild.name..'\n('..message.guild.id..')', inline = true},
							{name = 'Owner:', value = message.guild.owner.name..'\n('..message.guild.owner.id..')', inline = true},
							{name = 'Created at:', value = ct.month..'/'..ct.day..'/'..ct.year, inline = true},
							{name = 'Region:', value = message.guild.region, inline = true},
							{name = 'Members:', value = #message.guild.members, inline = true},
							{name = 'Text Channels:', value = #message.guild.textChannels, inline = true},
							{name = 'Voice Channels:', value = #message.guild.voiceChannels, inline = true},
							{name = 'Roles:', value = #message.guild.roles, inline = true},
							{name = 'Shard:', value = message.guild.shardId, inline = true}
						},
						color = discordia.Color.fromRGB(255, 215, 0).value,
						timestamp = discordia.Date():toISO('T', 'Z')
					}
				}
			end

			if args[1] ~= nil and not args[2] then
				if args[1]:match('<@!?(%d+)>') == '369244923574091790' then
					return message.channel:send('Prefix for this guild is `'..prefix..'`')
				end
			end

			if args[1] == prefix..'prefix' then
				if message.member:hasPermission(8) == true or message.author.id == '201443773077520384' then
					if not args[2] then
						return message.channel:send('Incomplete command.')
					else
						scstop = false
						for sacf = 1, #config.guilds.prefix do
							if config.guilds.prefix[sacf] == message.guild.id then
								scstop = true
								config.guilds.prefix[sacf+1] = args[2]
							elseif sacf == #config.guilds.prefix and scstop == false then
								table.insert(config.guilds.prefix, message.guild.id)
								table.insert(config.guilds.prefix, args[2])
							end
						end
						savec = table.concat(config.guilds.prefix, '","')
						pconf = io.open('config.txt', 'w')
						pconf:write('{"guilds":{"prefix":["'..savec..'"]}}')
						pconf:close()
						return message.channel:send("Prefix saved as `"..args[2].."`")
					end
				else
					return message.channel:send('You do not have enough permissions to perform this command.')
				end
			end

			if message.content == prefix..'permscreenshot' and message.author.id == client.owner.id then
				if permscreen == true then
					permscreen = false
					return message.channel:send('The '..prefix..'screenshot command has been disabled.')
				elseif permscreen == false then
					permscreen = true
					return message.channel:send('The '..prefix..'screenshot command has been enabled.')
				end
			end

			if args[1] == prefix..'e621' then
				if args[2] == nil then
					return message.channel:send('Invalid command: Empty arguments.')
				else
					myh = {["form:"] = {["login:"] = "MLG_Golden", ["password_hash:"] = "TJ93PvXEe8V444m9rXVzLAH"}}
					myheader = json.encode(myh)
					table.remove(args,1)
					ese = table.concat(args, '+')
					form = json.decode(myheader)
					--res, body = http.request('GET', 'https://e621.net/posts.json?tag='..ese, form)
					return print(table.concat(form, ''))
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
				return message.channel:send{
					embed = {
						title = '**GoldenDragon Dev**',
						thumbnail = {url = client.user.avatarURL},
						description = '**Bot Version**\nV1.6\n**Library**\nDiscordia\n**Lib Version**\n'..discordia.package.version..'\n**Information**\nThis bot was created and hosted by MLG Golden.\nAnd also has few commands which includes moderation, fun, and soon-to-be community idea given that can be implemented into this bot.\n**Guilds**\n'..#client.guilds..'\n**Members**\n'..out..'\n**Support**\nhttps://discord.gg/G9NcUTE',
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

			if args[1] == prefix..'fa' then
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
					return message.channel:send{
						embed = {
							title = prefix..'fa <subcommand> <input> [image number]',
							description = 'Subcommand: search, gallery\nDescription: Pulls image from search results on Fur Affinity.',
							color = discordia.Color.fromRGB(255, 215, 0).value
						}
					}
				elseif args[2] == 'gallery' then
					if not args[3] then
						return message.channel:send('Incomplete command.')
					else
						b = 1
                        fdata = {}
                        pbody = {}
                        rrbody = {}
                        rrrbody = {}
                        res, body = http.request('GET', 'https://www.furaffinity.net/gallery/'..args[3])
                        rbody = body:split(" ")
                        for i = 1, #rbody do
                            if string.match(rbody[i], 'src="//t.facdn.net/.-"') ~= nil then
                                rrbody[b] = rbody[i]
                                b = b + 1
                            end
                        end
                        for a = 1, #rrbody do
                            rrrbody[a] = rrbody[a]:split("//")[2]
                        end
                        for b = 1, #rrrbody do
                                pbody[b] = rrrbody[b]:split('"')[1]
                        end
                        for c = 1, #pbody do
                            fdata[c] = "http://"..pbody[c]
						end
						if tonumber(args[4]) ~= nil then
							fdp = tonumber(args[4])
						else
							fdp = 1
						end
						if fdata[fdp] == nil then
                        	message.channel:send{
                            	embed = {
                            	title = "FA Gallery",
                            	description = 'https://www.furaffinity.net/gallery/'..args[3]..'\nNo user/image found.',
                            	color = discordia.Color.fromRGB(255, 215, 0).value
                           		}
							}
						else
							message.channel:send{
                            	embed = {
                            	title = "FA Gallery",
                            	image = {url = fdata[fdp]},
                            	description = 'Image #'..fdp..'\nhttps://www.furaffinity.net/gallery/'..args[3],
                            	color = discordia.Color.fromRGB(255, 215, 0).value
                           		}
							}
						end
					end
				elseif args[2] == 'search' then
					if not args[3] then
						return message.channel:send('Incomplete command.')
					else
						b = 1
                        fdata = {}
                        pbody = {}
                        rrbody = {}
                        rrrbody = {}
                        res, body = http.request('GET', 'https://www.furaffinity.net/search/?q='..args[3])
                        rbody = body:split(" ")
                        for i = 1, #rbody do
                            if string.match(rbody[i], 'src="//t.facdn.net/.-"') ~= nil then
                                rrbody[b] = rbody[i]
                                b = b + 1
                            end
                        end
                        for a = 1, #rrbody do
                            rrrbody[a] = rrbody[a]:split("//")[2]
                        end
                        for b = 1, #rrrbody do
                                pbody[b] = rrrbody[b]:split('"')[1]
                        end
                        for c = 1, #pbody do
                            fdata[c] = "http://"..pbody[c]
						end
						if tonumber(args[4]) ~= nil then
							fdp = tonumber(args[4])
						else
							fdp = 1
						end
						if fdata[fdp] == nil then	
                        	message.channel:send{
                            	embed = {
                            	title = "FA Search",
                            	description = 'https://www.furaffinity.net/search/?q='..args[3]..'\nNo image found.',
                            	color = discordia.Color.fromRGB(255, 215, 0).value
                            	}
							}
						else
							message.channel:send{
                            	embed = {
                            	title = "FA Search",
                            	image = {url = fdata[fdp]},
                            	description = 'Image #'..fdp..'\nhttps://www.furaffinity.net/search/?q='..args[3],
                            	color = discordia.Color.fromRGB(255, 215, 0).value
                            	}
							}
						end
					end
				else
					return message.channel:send('Invalid subcommand, the subcommand is search and gallery.')
				end
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

			local function code(str)
				message.channel:send(string.format('```\n%s```', str))
			end

			local function exec(arg)
				if not arg then return end

				local lines = {}

				sandbox.require = require
				sandbox.client = client
				sandbox.message = message
				sandbox.http = http
				sandbox.guild = guild
				sandbox.timer = timer
				sandbox.discordia = discordia
				sandbox.uv = uv
				sandbox.sw = sw
				sandbox.sw2 = sw2
				sandbox.asw = asw
				sandbox.fs = fs
				sandbox.config = config
				sandbox.savec = savec
				sandbox.json = json
				sandbox.ffi = ffi
				sandbox.clib = clib
				sandbox.luatz = luatz
				sandbox.fdata = fdata
				sandbox.pp = pp
				sandbox.pdump = function(...)
					table.insert(lines, prettyLine(...)) 
				end
				sandbox.lines = lines
				--sandbox.print = function(...)
					--message.channel:send(...)
				--end
				sandbox = setmetatable(sandbox, { __index = _G })

				local fn, syntaxError = load(arg, 'GoldenDragon Dev', 't', sandbox)
				if not fn then return code(syntaxError) end

				if #lines > 0 then
					print('Success')
					return message.channel:send{content = table.concat(lines, '\n'), code = 'lua'}
				end

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

local token = os.getenv('GoldenDragon_DEV_Token')

if not token then
  error("Please set the token to an environment variable called 'GoldenDragon_DEV_Token'")
end

client:run('Bot '..token)
