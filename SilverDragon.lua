local discordia = require('discordia')
local timer = require('timer')
local uv = require('uv')
local prefix = 's!'
local sandbox = {}
local sw = discordia.Stopwatch()
local client = discordia.Client()
local choice = {'Yes.','No.','My thoughts says no.','My thoughts says yes.','Probably, probably not.','Yes, absolutely.','No, definitely not.','My reply is no.','My reply is yes.','Maybe.'}
discordia.extensions()
sw:start()

client:on('ready', function()
	print('Logged in as '.. client.user.username)
end)

client:on('messageCreate', function(message)
    if message.content == prefix..'ping' and not message.author.bot then
        local response = message:reply('Pong!')
	    if response then
		    response:setContent('Pong! '..'`'..math.abs(math.round((response.createdAt - message.createdAt)*1000))..' ms`')
        end
    end
end)

client:on('messageCreate', function(message)
    if message.content == prefix..'stop' and message.author.id == client.owner.id then
        message.channel:send('Stopping...')
        client:stop()
    end
end)

client:on('messageCreate', function(message)
    said = message.content:split(' ')
    if said[1] == prefix..'say' and not message.author.bot then
        table.remove(said, 1)
        timer.sleep(100)
        message.channel:send(table.concat(said, ' '))
        return message:delete()
    end
end)

client:on('messageCreate', function(message)
    if message.content == prefix..'restart' and message.author.id == client.owner.id then
        message.channel:send('Restarting...')
        os.execute('start4.bat')
    end
end)

client:on('messageCreate', function(message)
    if message.content == prefix..'uptime' and not message.author.bot then
        return message.channel:send('**Bot Uptime**\n'..tostring(sw:getTime())..'\n**System Uptime**\n'..tostring(discordia.Time.fromSeconds(uv.uptime())))
    end
end)

client:on('messageCreate', function(message)
    args = message.content:split(' ')
    if args[1] == prefix..'8ball' and not message.author.bot then
        if args[2] then
            choose = math.random(1, #choice)
            return message.channel:send{
                mentions = {message.author},
                content = ' '..choice[choose]
            }
        else
            return message.channel:send{
                mentions = {message.author},
                content = ' You can`t use 8ball without asking anything you silly.'
            }
        end
    end
end)

client:on('messageCreate', function(message)
    relayl = '512749559726735478'
    relayp = '512749591373021187'
    if message.channel.id == '430035544937070602' then
        rlog = client:getChannel(relayl)
        rlog:send('**'..message.author.username..'** `('..message.author.id..')`\n'..message.content)
    end
    if message.channel.id == '430019058205851658' then
        plog = client:getChannel(relayp)
        plog:send('**'..message.author.username..'** `('..message.author.id..')`\n'..message.content)
    end
end)

client:on('messageCreate', function(message)
    if message.content == prefix..'info' and not message.author.bot then
        percent = math.random(0,100)
        if percent >= 0 and percent <= 9 then
            bar = '▌          ▐'
        elseif percent >= 10 and percent <= 19 then
            bar = '▌█         ▐'
        elseif percent >= 20 and percent <= 29 then
            bar = '▌██        ▐'
        elseif percent >= 30 and percent <= 39 then
            bar = '▌███       ▐'
        elseif percent >= 40 and percent <= 49 then
            bar = '▌████      ▐'
        elseif percent >= 50 and percent <= 59 then
            bar = '▌█████     ▐'
        elseif percent >= 60 and percent <= 69 then                                                                                                                       
            bar = '▌██████    ▐'
        elseif percent >= 70 and percent <= 79 then
            bar = '▌███████   ▐'
        elseif percent >= 80 and percent <= 89 then
            bar = '▌████████  ▐'
        elseif percent >= 90 and percent <= 99 then
            bar = '▌█████████ ▐'
        elseif percent == 100 then
            bar = '▌██████████▐'
        end
        return message.channel:send{
            embed = {
                description = 'BarGraph testing: '..percent..'%\n`'..bar..'`'
            }
        }
    end
end)

client:on('messageCreate', function(message)
    args = message.content:split(' ')
    if args[1] == prefix..'ban' and not message.author.bot then
        if message.member:hasPermission(4) then
            if not args[2] then
                return message.channel:send{
                    embed = {
                        author = {name=message.author.name,icon_url=message.author.avatarURL},
                        title = 'Command: '..prefix..'ban',
                        description = 'Description: Ban a member from your guild.\nUsage: '..prefix..'ban [user] [reason]',
                        color = discordia.Color.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255)).value,
                        timestamp = discordia.Date():toISO('T', 'Z')
                    }
                }
            else
                person = args[2]
                if args[3] then
                    table.remove(args,1)
                    table.remove(args,1)
                    reason = table.concat(args, ' ')
                else
                    reason = 'No reasons given.'
                end
                if not message.mentionedUsers:iter()() then
                    return message.channel:send('I cannot ban "'..args[2]..'"')
                else
                    message.channel:send(person..' **was banned.** Reason: '..reason)
                    return message.guild:banUser(message.mentionedUsers:iter()().id, reason)
                end
            end
        end
    end
end)

client:on('messageCreate', function(message)
    gban = message.content:split(' ')
    if gban[1] == prefix..'globalban' and message.author.id == client.owner.id then
        if not gban[2] then
            return message.channel:send{
                embed = {
                    author = {name=message.author.name,icon_url=message.author.avatarURL},
                    title = 'Command: '..prefix..'globalban',
                    description = 'Description: Globally ban a member in any guild this bot lives in.\nUsage: '..prefix..'ban [user] [reason]',
                    color = discordia.Color.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255)).value,
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
end)

local token = os.getenv('SilverDragon_Token')

if not token then
  error("Please set the token to an environment variable called 'SilverDragon_Token'")
end

client:run('Bot '..token)
