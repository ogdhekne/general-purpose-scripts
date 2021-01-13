# README:

## Current directory structure:
<pre>
general-purpose-scripts/
├── canonmgmt
├── dmg2img
├── laptop-battery-mgmt.sh
├── oracle
│   ├── oracerts
│   ├── oracle11gr2mannualdb
│   ├── oracle11gr2mannualdb_v2
│   ├── start-stop
│   │   ├── init.d
│   │   │   └── oradb
│   │   └── systemd
│   │       ├── oracle.service
│   │       └── oradb
│   └── tbs
├── osp
│   ├── osp-multi-node.sh
│   └── osp.sh
├── README.md
├── scanserv
├── secureboot.sh
├── sif
├── swapfilec
└── ubuntu-gpinstaller
</pre>

### Description:
1. canonmgmt: Canon LBP2900b Laser print management utility for deb/rpm.

2. dmg2img: Wrapper over cli application dmg2img.

3. oracle:
	3.1 oracerts: 
	3.2 oracle11gr2mannualdb: Manual database creation for Oracle 11g R2 database
	3.3 oracle11gr2mannualdb_v2: Manual database creation for Oracle 11g R2 database - v2
	3.4 start-stop:
		3.4.1 init.d:
			3.4.1.1 oradb: 
		3.4.2 systemd:
			3.4.2.1 oracle.service:
			3.4.2.2 oradb:
	3.5 tbs: Utility script for creating , modifying and deleting tablespace.

4. osp:
	4.1 osp-multi-node.sh: 
	4.2 osp.sh: 

5. README.md: 

6. scanserv: 

7. secureboot.sh: 

8. sif: Utility script for searching text inside files.

9. swapfilec: Utility script for creating and deleting swapfile.

10. ubuntu-gpinstaller: Installation of VLC, alien, youtube-dl, gparted, ubuntu-tweak, wine1.6, gimp, vuze and audio codecs.