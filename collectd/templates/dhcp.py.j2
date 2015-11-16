#!/usr/bin/python

import datetime, collectd, os.path

def parse_leases(lease_file):
	leases = {}
	lease = {}
	in_lease = False
	for line in lease_file:
		if line.lstrip().startswith('#'):

			continue
		tokens = line.split()

		if len(tokens) == 0:
			continue
		key = tokens[0].lower()

		if key == 'lease':
			if in_lease:
				raise Exception('Parsing error')
			else:
				in_lease = True
				lease = {'id' : tokens[1]}

		elif key == 'starts' or key == 'ends':
			if not in_lease:
				raise Exception('Parsing error')
			else:
				lease[key] = datetime.datetime.strptime(tokens[2]+' '+tokens[3].rstrip(';'), '%Y/%m/%d %H:%M:%S')

		elif key == '}':
			in_lease = False
			leases[lease['id']] = lease
			lease = {}

	return leases

def count_active_leases(all_leases, now):
	count_active = 0
	count_all = 0
	for lease in all_leases.itervalues():
		count_all += 1
		if timestamp_inbetween(now, lease['starts'], lease['ends']):
			count_active += 1
	count_touch = count_all - count_active
	return count_active, count_touch


def timestamp_inbetween(now, start, end):
	return start < now < end

def read(data=None):
	leasefile = '/var/lib/dhcp/dhcpd.leases'
	if os.path.isfile(leasefile):
		lfile = open(leasefile, 'r')
		all_leases = parse_leases(lfile)
		lfile.close()
		count_active, count_touch = count_active_leases(all_leases, datetime.datetime.utcnow())
		vl = collectd.Values(type='gauge')
		vl.plugin='dhcp_leases'
		vl.type_instance = 'active'
		vl.dispatch(values=[count_active])
		vl = collectd.Values(type='gauge')
		vl.plugin='dhcp_leases'
		vl.type_instance = 'touched'
		vl.dispatch(values=[count_touch])


def write(vl, data=None):
	for i in vl.values:
		print "%s (%s): %f" % (vl.plugin, vl.type, i)

collectd.register_read(read)
collectd.register_write(write);

