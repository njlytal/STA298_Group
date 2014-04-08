#!/usr/bin/env python
##Strava Project
##Plotting based on Time of Day
##By: Hans Vasquez-Gross
from optparse import OptionParser
import matplotlib.pyplot as plt
import datetime
import numpy as np
import json
import pprint
import os.path
import glob

parser = OptionParser(usage="usage: %prog [options] output_file\n\nINFO", version="%prog 1.0")
parser.add_option("-d", "--directory", dest="indir_name", help="input json file directory")
parser.add_option("-o", "--out_dir", dest="outdir_name", help="output directory; Defaults to the current working directory", default="./")
parser.add_option("-v", "--verbosity", dest="verbosity_value", type="int", help="Level of verbosity printed to screen; Higher number means more info; 0|1|2; Default: 0", default=0)
(options, args) = parser.parse_args()


if __name__ == "__main__":

	##Parse directories and check if it exists
	if not os.path.exists(options.outdir_name):
		os.makedirs(options.outdir_name)

	##Read each file in the given directory
	for filename in glob.glob(os.path.join(os.path.normpath(options.indir_name), "*.json")):

		##Get file prefix, open file, and parse json data
		prefix = os.path.splitext(os.path.basename(filename))[0]
		if_handle = open(filename, 'r')
		json_data = if_handle.read()
		input_json = json.loads(json_data)

		num_activities = 0
		timearray = list()

		##Looping through the contents of the json file
		for activity in input_json:

			if options.verbosity_value > 0: print "ACTIVITY%s:%s\t" % (num_activities, activity)
			num_activities += 1

			##For each attribute on a given activity
			for item in activity:

				if options.verbosity_value > 1: print "DEBUG:%s\t%s" % (item, activity[item])

				##for this script, we are only looking at the start_date of the activity
				if "start_date_local" in item:
					datetimeConvert = datetime.datetime.strptime(activity[item], "%Y-%m-%d %H:%M:%S")
					timearray.append(datetimeConvert)

		#init arbitrary datetime for 24 hour window on plot
		x = np.array([datetime.datetime(2014, 4, 7, i, 0) for i in range(24)])

		##Init Data dictionary for counts
		dataDict = dict()
		for i in range(24):
			dataDict.setdefault(i, 0)

		##Count Totals
		for item in timearray:
			hour = item.hour
			dataDict[hour] += 1

		##Convert dict to array to use with plotting function
		y = list()
		for i in range(24):
			y.append(dataDict[i])
			


		# initialization of the plot and save
		figure = plt.figure(figsize=(15.0, 12.0))

		plt.xlabel('Time of Day')
		plt.ylabel('Occurrences')
		plt.grid(True)
		plt.title(prefix + '.json Daily Activity')
		plt.plot(x,y)
		#plt.show()
		outfile = prefix + ".png"
		out_filepathd = os.path.join(os.path.normpath(options.outdir_name), outfile)
		print "Saving PNG: %s" % out_filepathd	
		figure.savefig(out_filepathd)
