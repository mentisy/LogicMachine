# LogicMachine Libraries

This repository contains library scripts used with the [LogicMachine](https://openrb.com/logicmachine5-power-pmc/) product.
The product is often used in conjuction with a KNX based installation, supporting the building automation system.

Some of the scripts are in actual use in buildings today, and some are just made for testing and learning.

This repository is mainly created in order to keep a backup of the scripts, but if by some chance you want to use them, feel free. You can email me if you need assistance or have any questions. The email is found inside all user.x.lua scripts.

### API
A **very** shallow API class, enabling developers to send data to their own / other's API. Currently only supporting POST method requests.

### Alert
Send alert to a **Gmail** account (only service supported thus far). Provide credentials, recipient address and message before sending. Used when certain KNX events occurs and an alert is requried for logging or speedy diagnostics. 

### Backup
LogicMachines are like other computers vulnerable for crashes or defects. This script provides an easy way to create a backup to the local FTP server. It must then be uploaded, using some "cloud" service. The usage example will use Dropbox, or more specifically an API App created in Dropbox to support uploading files. 

The Dropbox class in this repository can be used to upload the backup to Dropbox. See usage example in the "usage.backup.lua" file. 

**Note:** The Dropbox App is only in Development mode, so can't be used by anyone else than me. If you want to use it, email me and I'll add you to supported users.

### Corridor Logic
Used in building automation to evaluate corridor lighting. Usually in office buildings, when at least one office is occupied, we want the corridor lighting in that area to remain on. Or even when one corridor is occupied (directly or indirectly through an occupied office), we want lighting in the entrance area or common staircases to remain on as well.

This script enables an easy way to evaluate whether one of these are occupied, and sends the evaluated value to designated outputs in the building. Provide a TAG for inputs and a TAG for outputs. The inputs can be PIR detectors and outputs are usually relays. These tags must then be applied to all relevant group addresses in the KNX bus. 

### KNX
Parse and create KNX addresses convenience methods
* Parse an address string (1/2/3) into main (1), middle (2) and sub (2) groups
* Create an address string by entering a main, middle and sub group.

### Dropbox
Upload files to Dropbox using this script. Dropbox App token must be provided.

### Messagebird
Send SMS using this script. A valid [MessageBird](https://messagebird.com/en) account is required. Specify the token in the constructor.

### DALI
Retrieve diagnostics from the DALI bus using the Siemens N 141/21 KNX/DALI Gateway. See [DALI read me file](DALI/README.md) for information.
