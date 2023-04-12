local BasePlugin = require("kong.plugins.base_plugin")
local clear_header = kong.service.request.clear_header

-- utils
local function is_empty(s)
    return s == nil or s == ''
end

local function contains (tab, val)
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

local function get_header_value(header_name)
    local h = ngx.req.get_headers()
    for k, v in pairs(h) do
        if string.lower(k) == string.lower(header_name) then
            return v
        end
    end
    return nil
end

local MtlsAcl = BasePlugin:extend()

MtlsAcl.VERSION = "1.0.0"
MtlsAcl.PRIORITY = 950

function MtlsAcl:new()
    MtlsAcl.super.new(self, "mtls-acl")
end

function MtlsAcl:access(plugin_conf)
    local certificate = get_header_value(plugin_conf.certificate_header_name)
    if not is_empty(certificate) then
		if not is_empty(plugin_conf.allow) then
		    if contains(plugin_conf.allow, certificate) then
				if (plugin_conf.hide_certificate_header) then
					clear_header(plugin_conf.certificate_header_name)
				end
		        return
			end
		end
		if not is_empty(plugin_conf.deny) then
		    if not contains(plugin_conf.deny, certificate) then
				if (plugin_conf.hide_certificate_header) then
					clear_header(plugin_conf.certificate_header_name)
				end
		        return
			end
		end
	end
    return kong.response.exit(403, {
        message = "You cannot consume this service"
    })

end

return MtlsAcl