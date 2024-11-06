# Intune Custom Compliance Samples

These are sample script for Intune Custom Compliance policies

## Reference:
https://learn.microsoft.com/en-us/mem/intune/protect/compliance-custom-json


## How to use them

### Add the detection script to Intune

1. Login into [Intune Admin Center](https://intune.microsoft.com)
2. Navigate to Devices > Compliance > Scripts or  Endpoint security > Device compliance > Scripts
3. Click Add > Windows 10 or Later. Provide a Name, description, and publisher.
4. Copy the contents of the script in the detection script settings. Then set:
    - Run this script using the logged on credentials > NO
    - Enforce script signature check > NO
    - Run script in 64 bit PowerShell Host > YES
5. Click Next > Create

### Creating the custom compliance Script

1. Login into [Intune Admin Center](https://intune.microsoft.com)
2. Go to Devices > Windows > Compliance
3. Click Create policy > Windows 10 and Later. Click Create
4. Provide a Name and description. Click Next
5. On the Compliance settings tab, expand _Custom Compliance_
    - Set Custom compliance to Require
    - Under Select your discovery script, select _Click to select_, and select the script that corresponds to this compliance policy
    - Under _Upload and validate the JSON file with your custom compliance settings_, click the file icon and browse to the JSON file.
        - Verify the Settings name, Operator and Value are accurate. There can be multiple
6. Click Next, Keep Action for noncompliance if this is being used for Autopilot
7. Click Next, select a tag or tags if required
8. Click Next, assign the policy to groups that contain either devices or users (recommend)
9. Click Next > Create