F= files/docker/systemctl.py
B= 2016

version1:
	@ grep -l __version__ */*.??* */*/*.??* | { while read f; do echo $$f; done; } 

version:
	@ grep -l __version__ */*.??* */*/*.??* *.py | { while read f; do : \
	; Y=`date +%Y` ; X=$$(expr $$Y - $B); D=`date +%W%u` ; sed -i \
	-e "/^ *__version__/s/[.]-*[0123456789][0123456789][0123456789]*\"/.$$X$$D\"/" \
	-e "/^ *__version__/s/[.]\\([0123456789]\\)\"/.\\1.$$X$$D\"/" \
	-e "/^ *__copyright__/s/(C) [0123456789]*-[0123456789]*/(C) $B-$$Y/" \
	-e "/^ *__copyright__/s/(C) [0123456789]* /(C) $$Y /" \
	$$f; done; }
	@ grep ^__version__ files/*/*.??*

help:
	python files/docker/systemctl.py help
copy cp:
	cp ../docker-systemctl-replacement/files/docker/systemctl.py files/docker/systemctl.py
2: copy

alltests: CH CP UA DJ
.PHONY: tests
tests: alltests

CH centos-httpd.dockerfile: ; ./testbuilds.py test_701
CP centos-postgres.dockerfile: ; ./testbuilds.py test_702
UA ubuntu-apache2.dockerfile: ; ./testbuilds.py test_721
DJ docker-jenkins: ; ./testbuilds.py test_90*

check: ;  ./testbuilds.py -vv 
test_%: ; ./testbuilds.py $@ -vv
real_%: ; ./testbuilds.py $@ -vv

3: tmp/systemctl3.py
tmp/systemctl.py tmp/systemctl3.py : files/docker/systemctl.py
	test -d tmp || mkdir tmp
	cp files/docker/systemctl.py $@
	sed -i -e "s|/usr/bin/python|/usr/bin/python3|" $@

op opensuse: ; ./testbuilds.py make_opensuse
ub ubuntu:   ; ./testbuilds.py make_ubuntu
ce centos:   ; ./testbuilds.py make_centos

clean:
	- rm -rf tmp/tmp.test_*
