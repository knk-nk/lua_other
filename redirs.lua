require 'shell'

function checkredirs(url)
	print ''
	local pref = {
		'/',
		'//',
		'/?',
		'/#',
		'/home',
		'/home.html',
		'/home.htm',
		'/home.php',
		'/index.html',
		'/index.htm',
		'/index.php'
	}
	local page = curl(url, nil, 1)
	local http = curl('http://'..url:gsub('http[s]?://', ''), nil, 1)
	if http then print 'HTTP is Available. This is a problem.' end
	for i,v in ipairs(pref) do
		local duplicate = curl(url..v, nil, 1)
		if duplicate == page then
			print('Duplicate found: '..url..v)
		end
	end
end

print 'Please specify URL of the website to scan for homepage redirects:'
checkredirs(io.read())
print '\nPress any key to exit'
io.read()
