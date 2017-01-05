Warning: Known conflicts:

    # rpm -q --conflicts ea-apache24-mod_pagespeed
    ea-apache24-mod_ruid2
    
If mod_ruid2 is currently installed, mod_pagespeed will not be able to install.

To use this autoinstaller for mod_pagespeed on cPanel/EA4 run the following:

    /bin/sh <(curl -s https://raw.githubusercontent.com/cPLevey/ea4.pagespeed.autoinstaller/master/ea4.pagespeed.sh)
