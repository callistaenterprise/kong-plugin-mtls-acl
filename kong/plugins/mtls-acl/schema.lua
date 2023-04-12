local typedefs = require "kong.db.schema.typedefs"

return {
    name = "mtls-acl",
    fields = {
        { consumer = typedefs.no_consumer },
        { protocols = typedefs.protocols_http },
        {
            config = {
                type = "record",
                fields = {
                    { allow = { type = "array", required = false, elements = { type = "string" } } },
                    { deny = { type = "array", required = false, elements = { type = "string" } } },
                    { certificate_header_name = { type = "string", required = true } },
                    { hide_certificate_header = { type = "boolean", required = false, default = false } }
                },
            },
        },
    },
    entity_checks = {
        { only_one_of = { "config.allow", "config.deny" }, },
        { at_least_one_of = { "config.allow", "config.deny" }, },
    },
}