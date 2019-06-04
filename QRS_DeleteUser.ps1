# MIT License
# 
# Copyright (c) 2019 Yoichi Hirotake
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE`
# SOFTWARE.


$hdrs = @{}
$hdrs.Add("X-Qlik-Xrfkey","examplexrfkey123")
$hdrs.Add("X-Qlik-User", "UserDirectory=Domain;UserId=Administrator") #UserDirectory and UserID is the one which you run Qlik Sense Services
#$hdrs
#objectID is the UserID of the user you want to delete from Qlik Sense.
$body = @('{"items":[{"type":"User","objectID":"db152412-0e8b-4ce5-8360-edd09932b172"}]}')
#$body
$xrfkey="examplexrfkey123"
#$xrfkey
$cert = Get-ChildItem -Path "Cert:\CurrentUser\My" | Where {$_.Subject -like '*QlikClient*'}
#$cert
$Data = Get-Content C:\ProgramData\Qlik\Sense\Host.cfg
$FQDN = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($($Data)))
#$FQDN
$DeleteUser1of3 = Invoke-RestMethod -Uri "https://$($FQDN):4242/qrs/selection?xrfkey=$($xrfkey)" -Method POST -Headers $hdrs -Body $body -ContentType 'application/json' -Certificate $cert
$DeleteUser1of3
$return = $DeleteUser1of3 | Out-String
#$return
$rtn = $return  -replace "`r`n",','
$rtn = $rtn -replace "\s", ''
$rtn = $rtn.Remove(0,2)
#$rtn
$rtn = $rtn.Split(",")
$rtn = $rtn.Split(":")
#$rtn
#$id = $rtn[0] #$id
#$id
$idv = $rtn[1] #$idv
#$idv
$DeleteUser2of2 = Invoke-RestMethod -Uri "https://$($FQDN):4242/qrs/Selection/$($idv)/User?xrfkey=$($xrfkey)" -Method DELETE -Headers $hdrs -ContentType 'application/json' -Certificate $cert
$DeleteUser3of2 = Invoke-RestMethod -Uri "https://$($FQDN):4242/qrs/Selection/$($idv)?xrfkey=$($xrfkey)" -Method DELETE -Headers $hdrs -ContentType 'application/json' -Certificate $cert