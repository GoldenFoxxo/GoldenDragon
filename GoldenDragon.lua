local discordia = require('discordia')
local timer = require('timer')
local prefix = 'g!'
discordia.extensions()

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

client:on('guildCreate', function()
  shouldUpdateGuildsCount = true
  print('Invited to Guild')
end)

client:on('guildDelete', function()
  shouldUpdateGuildsCount = true
  print('Kicked from Guild')
end)

client:on('messageCreate', function(message)

	if message.author.id ~= '369244923574091790' then
		
		--Debug use only
		--print('Guild: '..message.guild.name..'\nChannel: '..message.channel.name..'\nUser: '..message.author.name..'\nMessage: '..message.content..'\n')

		local guild = message.guild
		local args = message.content:split(' ')
		local member = message.member
		local logc = '434836657506746378'
		
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
			message.channel:send {
				embed = {
					title = 'Heres the list of commands. The prefix is `'..prefix..'`',
					fields = {
						{name = 'ping', value = 'Just a response testing.', inline = false},
						{name = 'sendnoods', value = 'Sends dry, naked noods.', inline = false},
						{name = 'time', value = 'Tells you about date and time.', inline = false},
						{name = 'copycat', value = 'Makes bot say what you said.', inline = false},
						{name = 'ban', value = 'Bans users. Reason and time not included, mentions required.', inline = false},
						{name = 'random', value = 'Picks out random number you placed in input, eg. random 0 10', inline = false},
						{name = 'unban', value = 'Unbans users. ID required to unban.', inline = false},
						{name = '8ball', value = 'Magic 8 ball and it answers your burning questions.', inline = false},
						{name = 'hackban', value = 'Bans users by id. *in development and check bans in server settings to see if its successful ban*', inline = false},
						{name = 'stop', value = 'Stops or disables the bot. *Bot owner command only!*', inline = false},
						{name = 'restart', value = 'Restarts the bot. *Bot owner command only!*', inline = false},
						{name = 'changelog', value = 'Shows you information and version what updated about this bot.', inline = false},
						{name = 'eval', value = 'Evalulates code in Lua sandbox mode. *In development*', inline = false},
						{name = 'purge', value = 'Deletes amount of messages given. *Glitched or Bugged*', inline = false},
						{name = 'hug', value = 'Hug someone!', inline = false}
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
				content = '**GoldenDragon v1.2**\n+Added logging system.\n+Added independant prefix system.',
			}
		end
		
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
		
		--swearlist = {'fuck','shit','cunt','bitch','asshole','slut','fucking','faggot','nigger'}
		--for sl = 1, #swearlist do
			--for swearscan = 1, #args do
				--if swearlist[sl] == string.lower(args[swearscan]) then
					--require('timer').sleep(100)
					--message:delete()
					--return message.channel:send{
						--mentions = {message.author},
						--content = 'Please do not swear.',
					--}
				--end
			--end
		--end

		if message.content == prefix..'sendnoods' then
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
			nrand = math.random(1,5)
			if nrand == 1 then
				return message.channel:send{
					file = 'nood1.jpg',
				}
			elseif nrand == 2 then
				return message.channel:send{
					file = 'nood2.jpg',
				}
			elseif nrand == 3 then
				return message.channel:send{
					file = 'nood3.png',
				}
			elseif nrand == 4 then
				return message.channel:send{
					file = 'nood4.jpg',
				}
			elseif nrand == 5 then
				return message.channel:send{
					file = 'nood5.jpg',
				}
			end
		end

		if message.content == 'Hello' then
			client:getChannel(logc):send{
				embed = {
					title = 'Responder',
					fields = {
						{name = 'Information', value = '```User: '..message.author.name..'\nGuild: '..message.guild.name..'\nChannel: '..message.channel.name..'\nCommand: '..args[1]..'```', inline = false},
						{name = 'Full Information', value = '```'..message.content..'```', inline = false}
					},
					color = discordia.Color.fromRGB(255, 215, 0).value,
					timestamp = discordia.Date():toISO('T', 'Z')
				}
			}
			message.channel:send('Hello human :D')
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
				os.execute('reboot.bat')
			else
				message.channel:send('Only bot owner is allowed to use this command!')
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

		--if args[1] == 'g?random' then
			--if not args[2] or not args[3] then
			--	return message.channel:send('Imcomplete command')
		--	else
			--	least = string.match(args[2],'(%d+)')
			--	most = string.match(args[3],'(%d+)')
			--	message.channel:send(math.random(least,most))
		--	end
		--end

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
				if message.member:hasPermission(8) == true then
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
				if message.member:hasPermission(8) == true then
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
				if message.member:hasPermission(8) == true then
					message.guild:unbanUser(args[2])
					return message.channel:send('**'..args[2]..' unbanned!**')
				else
					return message.channel:send('You do not have enough permissions to perform this command.')
				end
			end
		end

		if args[1] == prefix..'copycat' then 
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
			timer.sleep(100)
			message:delete()
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
				ballc = {'Yes.','No.','My thoughts says no.','My thoughts says yes.','Probably, probably not.','Outlook not so good.','Yes, absolutely.','No, definitely not.','My reply is no.','My reply is yes','Outlook good'}
				message.channel:send{
					mentions = {message.author},
					content = ballc[math.random(1,#ballc)],
				}
			end
		end

		if args[1] == prefix..'purge' then
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
			if message.member:hasPermission(8) == true then
				timer.sleep(100)
				message.channel:bulkDelete(args[2]+1)
				timer.sleep(100)
				message.channel:send('Purged '..args[2]..' Messages.')
			else
				message.channel:send('You do not have enough permissions to perform this command.')
			end
		end

		local sandbox = {
			math = math,
			string = string,
			discordia = discordia,
			client = client,
			io = io,
			guild = guild
		}

		local function code(str)
			message.channel:send(string.format('```\n%s```', str))
		end

		local function exec(arg)
			if not arg then return end
			sandbox.message = message
			local fn, syntaxError = load(arg, 'DiscordBot', 't', sandbox)
			if not fn then return code(syntaxError) end
			local success, runtimeError = pcall(fn)
			if not success then return code(runtimeError) end
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
				if message.author.id == client.owner.id or message.author.id == '196443959558406144' then
					table.remove(args,1)
					earg = table.concat(args,' ')
					code(earg)
					exec(earg)
				else
					return message.channel:send('Bot Owner And Developers Only!')
				end
			end
		end

	end
end)

local token = os.getenv('GoldenDragon_Token')

if not token then
  error("Please set the token to an environment variable called 'GoldenDragon_DEV_Token'")
end

client:run('Bot '..token)
