# This file is managed by ansible, don't make changes here - they will be overwritten.
log syslog { debug, trace, info, remote, warning, error, auth, fatal, bug };

router id {{ff_network.v4_network | ipaddr(server_id) | ipaddr('address') }};

table ffnet;

filter freifunk {
        if net ~ {{ffms_routing.net}} then accept;
        reject;
};

protocol direct {
        interface "lo";
        interface "tun-*";
        interface "gre-*";  
        interface "bck-*";  
        table ffnet;
}


protocol kernel {
        device routes;
        import all;
        export all;                     # Default is export none
        table ffnet;
        kernel table 42;                # Kernel table to synchronize with (default: main)
}

protocol device {
        scan time 10;                   # Scan interfaces every 10 seconds
}

protocol ospf 'p6-ospf-ffnet' {
  table ffnet;
  import filter freifunk;
  export all;

  area 0.0.0.0 {
   interface "gre-*"  {
        bfd;
   };
   interface "bck-*"  {
        bfd;
   };
 };
};

function is_default() {
        return (net ~ [::/0]);
}

filter hostroute {
{% if 'ffms_tun_to' in hostvars[inventory_hostname] %}
{% for domaene in domaenen|dictsort %}
{% set step = 0 %}
{% for host in ffms_tun_to %}
{% if 'domaene-'+domaene[0] in hostvars[host.host_name].group_names and step == 0 %}
        if net ~ {{hostvars[host.host_name].ff_network.v6_network | regex_replace('..::/\d+$','00::/56')}} then accept;
{% set step = 1 %}
{% endif %}
{% if "domaenenliste" in hostvars[host.host_name] and domaene[0] in hostvars[host.host_name].domaenenliste and step == 0 %}
        if net ~ {{domaene[1].ffv6_network | regex_replace('..::/\d+$','00::/56')}} then accept;
{% set step = 1 %}
{% endif %}
{% endfor %}
{% endfor %}
{% endif %}
        reject;
}

{% if 'ffms_tun_to' in hostvars[inventory_hostname] %}
{% for domaene in domaenen|dictsort %}
{% set step = 0 %}
{% for host in ffms_tun_to %}
{% if 'domaene-'+domaene[0] in hostvars[host.host_name].group_names and step == 0 %}
protocol static static_domaene{{domaene[0]}} {
        table ffnet;
        route {{hostvars[host.host_name].ff_network.v6_network | regex_replace('..::/\d+$','00::/56')}} reject;
}

{% set step = 1 %}
{% endif %}
{% if "domaenenliste" in hostvars[host.host_name] and domaene[0] in hostvars[host.host_name].domaenenliste and step == 0 %}
protocol static static_domaene{{domaene[0]}} {
        table ffnet;
        route {{domaene[1].ffv6_network | regex_replace('..::/\d+$','00::/56')}} reject;
}

{% set step = 1 %}
{% endif %}
{% endfor %}
{% endfor %}
{% endif %}

# ibgp zwischen den gateways
template bgp internal {
        table ffnet;
        local as {{ff_network.as_number}};
        import filter {
                preference = 99;
                accept;
        };
        export where source = RTS_BGP;
        gateway direct;
        direct;
        next hop self;
};


# Uplink zum FF Rheinland
template bgp uplink {
        table ffnet;
        local as {{ff_network.as_number}};
        import where is_default();
        export filter hostroute;
        gateway recursive;
}

{% for tun in ffrl_tun %}
protocol bgp ffrl_{{tun.name}} from uplink {
        description "Rheinland Backbone";
        source address {{tun.v6_local | ipaddr('address')}};
        neighbor {{tun.v6_remote | ipaddr('address')}} as 201701;
};

{% endfor %}
