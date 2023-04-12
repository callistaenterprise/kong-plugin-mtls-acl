# kong-plugin-mtls-acl

**kong-plugin-mtls-acl** is an Open Source plugin for [Kong](https://github.com/Mashape/kong) which restricts
access based on certificate information provided in an HTTP header. It is similar (but simpler) than the
[acl](https://docs.konghq.com/hub/kong-inc/acl/) built-in plugin.

This plugin requires an [mtls-auth](https://github.com/callistaentrprise/kong-plugin-mtls-auth)
plugin to have been already enabled on the Service or Route.

The implementation of this plugin was inspired by the [acl](https://docs.konghq.com/hub/kong-inc/acl/) and
[oidc-acl](https://github.com/pravin-raha/kong-plugin-oidc-acl) plugins.

## Install

Install luarocks and run the following command

    luarocks install kong-plugin-mtls-acl

You also need to set the KONG_PLUGINS environment variable

    export KONG_PLUGINS=mtls-auth,mtls-acl

## Configuration

To enable the plugin for a service:

    curl -X POST http://localhost:8001/services/{ID}/plugins \
        --data "name=mtls-acl"  \
        --data "config.allow=client1" \
        --data "config.allow=client2"

To enable the plugin using declarative config in `kong.yml`:

    plugins: 
    - name: mtls-auth
      config:
        allow:
		- client1
		- client2


| Form Parameter            | Default| Required        | Description                                                                               |
|---------------------------|--------|-----------------|-------------------------------------------------------------------------------------------|
| `certificate_header_name` |        | true            | The name of the HTTP header from where certificate information is going to be extracted. This should be same as what you have set in mtls-auth plugin. |
| `hide_certificate_header` | false  | false           | Flag that if enabled (true), prevents the `certificate_header_name` to be sent in the request to the Upstream service. |
| `allow`                   |        | *semi-optional* | The certificate(s) to allow                                                               |
| `deny`                    |        | *semi-optional* | The certificate(s) to deny                                                                |

You can’t configure an ACL with both allow and deny configurations. An ACL with an allow provides a positive security model,
in which the configured groups are allowed access to the resources, and all others are inherently rejected. By contrast,
a deny configuration provides a negative security model, in which certain groups are explicitly denied access to the resource
(and all others are allowed).

## License

Copyright 2023 Björn Beskow

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.