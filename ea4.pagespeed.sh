#!/bin/sh
#
# mod_pagespeed EA4 auto installer
# Dirty rough draft but works.
#

# Build/work Directory
BUILD_DIR=/root/ea4_mod_pagespeed;
	if [ ! -d "$BUILD_DIR" ]; then
		mkdir -p "$BUILD_DIR";
	fi

# Install required RPM packages
yum -y install rpm-build cpio ea-apache24-mod_version;

# Download mod_pagespeed RPM
wget -P "$BUILD_DIR/" https://github.com/Prajithp/cpanel/raw/master/EA4/ea-apache24-mod_pagespeed-latest-stable.src.rpm;

# Create appropriate macro file
if [ ! -f /etc/rpm/macros.apache2 ]; then
	touch /etc/rpm/macros.apache2;
fi

if [ ! -s /etc/rpm/macros.apache2 ]; then
	cat > /etc/rpm/macros.apache2 <<'_EOF'
%_httpd_mmn 20120211x8664
%_httpd_apxs /usr/bin/apxs
%_httpd_dir /etc/apache2
%_httpd_bindir %{_httpd_dir}/bin
%_httpd_modconfdir %{_httpd_dir}/conf.modules.d
%_httpd_confdir %{_httpd_dir}/conf.d
%_httpd_contentdir /usr/share/apache2
%_httpd_moddir /usr/lib64/apache2/modules
_EOF
fi

# RPM rebuild
rpmbuild --rebuild "$BUILD_DIR/ea-apache24-mod_pagespeed-latest-stable.src.rpm";

# Check if RPM was made
if [ -f /root/rpmbuild/RPMS/x86_64/ea-apache24-mod_pagespeed-latest-stable.x86_64.rpm ]; then
	echo "RPM made successfully.";
		# Proceed 
			rpm -ivh /root/rpmbuild/RPMS/x86_64/ea-apache24-mod_pagespeed-latest-stable.x86_64.rpm;

			if [ ! -z "$(rpm -qa |grep pagespeed)" ];
				then echo "RPM is installed.";
					/scripts/restartsrv_httpd;
						# Apache module list
						if [ ! -z "$(httpd -M |grep pagespeed)" ]; then
								echo "mod_pagespeed is installed:";
								echo "====";
								httpd -M |grep pagespeed;
								echo "====";
							else 
								echo "Looks like something went wrong."
						fi
				else
					echo "RPM didnt install. FAIL";
			fi
	echo "RPM build failed. FAIL";
fi
