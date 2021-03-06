local stringy = require "stringy"
local oxd = require "kong.plugins.kong-openid-rp.helper"
local common = require "kong.plugins.kong-openid-rp.common"
local singletons = require "kong.singletons"

local function register(config)
    if not common.isempty(config.oxd_id) then
        return true
    end

    if (not common.isempty(config.scope)) then
        config.scope = config.scope .. ",openid,uma_protection,uma_authorization"
        config.scope = common.split(config.scope, ",")
    else
        config.scope = "openid,uma_protection,uma_authorization"
        config.scope = common.split(config.scope, ",")
    end

    if (not common.isempty(config.client_logout_uris)) then
        config.client_logout_uris = common.split(config.client_logout_uris, ",")
    end

    if (not common.isempty(config.response_type)) then
        config.response_type = common.split(config.response_type, ",")
    end

    if (not common.isempty(config.grant_types)) then
        config.grant_types = common.split(config.grant_types, ",")
    end

    if (not common.isempty(config.acr_values)) then
        config.acr_values = common.split(config.acr_values, ",")
    end

    if (not common.isempty(config.client_request_uris)) then
        config.client_request_uris = common.split(config.client_request_uris, ",")
    end

    if (not common.isempty(config.client_logout_uris)) then
        config.client_logout_uris = common.split(config.client_logout_uris, ",")
    end

    if (not common.isempty(config.contacts)) then
        config.contacts = common.split(config.contacts, ",")
    end

    --    if (common.isempty(config.authorization_redirect_uri)) then
    --        config.authorization_redirect_uri = "https://" .. self.req.headers.host .. "/consumers/" .. config.consumer_id .. "/login"
    --    end
    --
    if (common.isempty(config.post_logout_redirect_uri)) then
        config.post_logout_redirect_uri = config.authorization_redirect_uri
    end

    if (not common.isHttps(config.authorization_redirect_uri)) then
        ngx.log(ngx.ERR, "authorization_redirect_uri: It does not start from 'https://'")
        return false
    end

    local oxd_result = oxd.register(config)
    if (oxd_result.result == false) then
        ngx.log(ngx.ERR, "Failed to registered site")
        return false
    end

    config.oxd_id = oxd_result.data.oxd_id
    config.client_id = oxd_result.data.client_id
    config.client_secret = oxd_result.data.client_secret

    return true
end

return {
    no_consumer = true,
    fields = {
        authorization_redirect_uri = { type = "string" },
        op_host = { type = "string", required = true },
        post_logout_redirect_uri = { type = "string" },
        application_type = { type = "string" },
        response_types = { type = "string" },
        grant_types = { type = "string" },
        scope = { type = "string" },
        acr_values = { type = "string" },
        client_name = { type = "string" },
        client_jwks_uri = { type = "string" },
        client_token_endpoint_auth_method = { type = "string" },
        client_request_uris = { type = "string" },
        client_logout_uris = { type = "string" },
        client_sector_identifier_uri = { type = "string" },
        contacts = { type = "string" },
        client_id = { type = "string" },
        client_secret = { type = "string" },
        oxd_host = { type = "string", required = true }
    },
    self_check = function(schema, plugin_t, dao, is_updating)
        return register(plugin_t), "Failed to register API on oxd server (make sure oxd server is running on oxd_host specified in configuration)"
    end
}