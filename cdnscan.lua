-- Check for CDN or popular API list on a website
require 'shell'

-- List of domain patterns to check
local cdnlist = {
	Google = {
		'google.com',
		'com.google',
		'maps.google',
		'adgoogle.',
		'gstatic.',
		'google-analytics',
		'googleanalytics',
		'googletagmanager',
		'googletagservices',
		'googleoptimize',
		'googleapis.',
		'googlecdn.',
		'googlecode.',
		'googlecommerce.',
		'googledomains.',
		'googledrive.',
		'googlee.',
		'googleearth.',
		'googlemaps.',
		'googleadservices.',
		'withgoogle.com',
		'googlesource.com',
		'googlehosted.com',
		'crashlytics.com',
		'android.com',
		'googlevads-cn.',
		'googleusercontent.',
		'googlesyndication.',
		'2mdn-cn.net',
		'2mdn.net',
		'ai.google',
		'apigee.',
		'app-measurement.com',
		'firebaseapp.com',
		'aswpsdkeu.com',
		'mozgcp.net',
		'bg-call-donation-',
		'cloud.run',
		'digitalkeypairing.org',
		'g.cn',
		'ggpht.com',
		'gmail.com',
		'gmodules.com',
		'goo.gle',
		'looker.com',
		'perplexity.ai',
		'photos.app.goo',
		'translate.goog',
		'tv.google',
		'www.blogger.com',
	},
	Amazon = {
		'amazon.',
		'amazonaws.',
		'cloudfront.net',
		'a2z.com',
		'amazontrust.',
	},
	Microsoft = {
		'microsoft.com',
		'live.com',
		'msftconnecttest.com',
		'sfx.ms',
		'microsoftapp',
		'appcenter.ms',
		'contoso.onmicrosoft',
		'azure.microsoft',
		'azurewebsites.net',
		'management.azure',
	},
	Facebook = {
		'facebook.',
		'fbstatic',
		'fbcdn-',
		'fbcdn.',
		'fbsbx.',
		'fb.com',
		'fbexternal-',
		'fbpigeon.',
		'facebook-hardware.',
		'internet.org',
		'messenger.com',
		'facebookmarketingpartners',
		'fb.me',
		'oculus.com',
		'oculusvr.com',
		'wit.ai',
		'applinks.org',
		'n888688.com',
		'friendfeed-media.',
		'atlassolutions.',
		'heji32.com',
		'facebooklive.',
	},
	Instagram = {
		'instagram.com',
		'api.instagram',
		'cdninstagram.com',
		'instagrampartners.',
		'ig.me',
		'instagr.am',
		'igsonar.com',
	},
	Twitter = {
		'twitter.com',
		't.co',
		'x.com',
		'twimg.com',
		'pscp.tv',
		'twtrdns.net',
		'twttr.com',
		'periscope.tv',
		'tweetdeck.com',
		'twitpic.com',
		'twitter.co',
		'twitterinc.com',
		'twitteroauth.com',
		'twitterstat.us',
	},
	WhatsApp = {
		'whatsapp.',
		'wa.me',
		'whatsappbrand.',
	},
	Yandex = {
		'yandex.ru',
		'yandex.com',
		'ya.ru',
	},
}

-- Main logic
local function scan(url)
	local page = curl(url)
	local domain = url:gsub('http[s]?://', ''):gsub('/.+', '')
	local pref = os.date('.%y%m%d.%H%M%S.cdnscan.txt')
	local exists, list = {}, {}

	-- Get a list of domains
	print '\nScanning for domains...'
	for dom in page:gmatch('http[s]?://(.-)[/"]') do
		if not exists[dom] then
			exists[dom] = 1
			table.insert(list, dom)
		end
	end

	-- Print domains matching {cdnlist} entries
	for _,x in ipairs(list) do
		for name, arr in pairs(cdnlist) do
			for _,y in ipairs(arr) do
				y = y:gsub('[.]', '[.]'):gsub('[-]', '[-]'):gsub('[+]', '[+]')
				if x:match(y) then
					print(name..' API/CDN found:	'..x)
				end
			end
		end
	end

	-- Save to file or print the domain list
	io.write '\nWrite results to a file? (print otherwise) (y/N): '
	local r = io.read()
	if r ~= '' then
		print('\nWriting to file: "'..domain..pref..'" ...')
		local f = io.open(domain..pref, 'w')
		f:write(table.concat(list, '\n'))
		f:close()
	else
		print('\n'..table.concat(list, '\n'))
	end
end

-- CLI loop
local function run()
	print 'Please specify URL of the webpage to scan:'
	local url = io.read()
	if not url:match('http[s]?://') then
		url = 'https://'..url
	end
	scan(url)

	io.write '\nExit? (Y/n): '
	local r = io.read()
	if r ~= '' then
		clear(); run()
	end
end

run()
