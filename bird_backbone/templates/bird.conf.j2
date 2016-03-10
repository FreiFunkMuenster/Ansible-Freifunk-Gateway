# This file is managed by ansible, don't make changes here - they will be overwritten.
log syslog all;
router id {{ff_network.v4_network | ipaddr(server_id) | ipaddr('address') }};

table ffnet;


filter freifunk {
  if net ~ 10.43.0.0/16 then accept;
  if net ~ 10.0.0.0/16 then accept;
  if net ~ 192.168.0.0/16 then accept;
  if net ~ 185.66.193.48/29 then accept;
  reject;
};


protocol direct {
  interface "lo";
  interface "gre-*";
  interface "bck-*";
  interface "tun-*";
  table ffnet;
};


protocol bfd 'p4-bfd-ffnet' {
  interface "gre-*";
  interface "bck-*";
  multihop {
    passive;
  };
};


protocol ospf 'p-ospf-ffnet' {
  table ffnet;
  import filter freifunk;
  export all;
  area 0.0.0.0 {
    interface "gre-*" {
    };
    interface "bck-*" {
    };
    interface "lo" {
	stub;
    };
  };
};

protocol kernel 'p-kernel-ff' {
  device routes;
  import all;
  export all;
  kernel table 42;
  table ffnet;
};

protocol device {
  scan time 8;
};

function is_default() {
  return (net ~ [0.0.0.0/0]);
};


filter hostroute {
  if net ~ {{server_ipv4_nat | ipaddr('address')}}/32 then accept;
  reject;
};


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


# Uplink über ff Rheinland
template bgp uplink {
  table ffnet;
  local as {{ff_network.as_number}};
  import where is_default();
  export filter hostroute;
  next hop self;
  multihop 64;
  default bgp_local_pref 200;
  default bgp_med 1;
};

# Todo: durch das /31 funktioniert ipaddr() nicht korrekt, klären, ob /31 in der config entfernt werden kann und dann regex entfernen
{% for tun in ffrl_tun %}
protocol bgp ffrl_{{tun.name}} from uplink {
  source address {{tun.v4_local | ipaddr('address')}};
  neighbor {{tun.v4_remote | regex_replace("^(\d+\.\d+\.\d+\.\d+)/\d+$","\\1")}} as 201701;
{% if loop.first %}
  default bgp_local_pref 201;
  default bgp_med 1;
{% endif %}
};

{% endfor %}
