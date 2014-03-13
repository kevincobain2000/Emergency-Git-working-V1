### Keywords

##### English

emergency, police, hospital, fire, siren, shout out, countries, help contact numbers

##### Chinese

紧急情况, 呼叫, 警方, 消防, 医院, 国家, 根据位置

##### Indonesian

darurat, suara, memanggil, polisi, pemadam kebakaran, rumah sakit, kontak, negara

##### Malay

Kecemasan, Lampu Suluh, Bunyi, Pilih Hubungi, Panggil, Polis, Pemadam Kebakaran, Negara 

##### French

urgences, Son, contact, Appel, Police, Feu, Hôpital, Pays

##### Japanese

緊急, サウンド, 電話 , コンタクト, 国, 警察, 消防, 病院

##### korean

경고, 소리, 전화걸다, 경찰, 불, 병원, 국가

##### Vietnamese
Khẩn Cấp , Báo Động, Cảnh Sát, Cứu Hỏa, Bệnh Viện, Đất Nước

##### Spanish

Emergencia, Sonido, contacto, Llamar, Policía, Fuego, Hospital, País 

##### arabic
حالة طوارئ, صوت, إجراء اتصال, شرطة, إطفاء, مستشفى, البلد

##### german
Notfall, Taschenlampe, Klang, Polizei, Feuerwehr, Krankenhaus

#### NEXT TO DO

1. Make Flashlight button to SOS 
2. While submitting update CHANGE THE KEYWORDS TO RESPECTIVE LANGUAGES
3. Add info button for latest updates on the earthquake api (http://earthquake.usgs.gov/earthquakes/catalogs/eqs1day-M2.5.txt)


#### ★ iPhone 5 iOS 6 Ready ★

help.ME in any Emergency, Blackout, Molesters, Threat, Natural disasters ...

- ★ Flashlight
- ★ Sound Attention - Louder than voice !
- ★ My Emergency Contact - Call, SMS, Email - Quicker than finding one in Panic !
- ★ Whole World's Police, Fire & Hospital Phone Numbers
- ★ Shout out help.ME on Facebook, Twitter - Someone will get help ASAP !
- ★ Auto Append Geo Location - To precise Street Name


#### Features

- ▪ Beautiful on Retina Display.
- ▪ Equips you with emergency gadgets and contacts.
- ▪ Customizable message for any emergency, with option to appending location.
- ▪ Choose one contact's Phone Number from your Address Book as Emergency Contact.
- ▪ Feel free to customize default Police, Fire & Hospital Numbers to your local numbers.
- ▪ Flying to a different country, just pick a new country from settings and numbers are set !


#### 11 Languages Supported

Arabic, Chinese - Simplified, Dutch, English, French, Indonesian, Japanese, Korean, Malay, Spanish and Vietnamese.

#### Notes


- ‣ Posting on Facebook requires iOS 6.0 or above

#### Requires


- ✔ iOS 5 or above
- ✔ iPhone 3GS, iPhone 4, 4s
- ✔ Optimized for iPhone 5


help.me, torch, flashlight, emergency, police, hospital, fire, torch, siren

### UPDATES

#### SCRIPT REMOVED


```
  python /Users/kevincobain2000/Documents/iPhoneApps/Emergency-V/localize.py --mainIdiom=en --mainStoryboard=temp/en.lproj/MainStoryboard.storyboard fr ko vi id ms ja zh-Hans de es ar
```

#### DONOT USE THE FOLLOWING

The file localize.py must be in this directory

```
  $HOME/Dropbox/iPhoneApps/Emergency-V/Emergency-Git/localize.py
```

or change the path by

1. click the project at the top ``temp 1 target, iOS SDK 6.0``
2. Go to ``Build Phases``
3. Expand ``Run Script``
4. Change the path to ``localize.py``


#### Notes


```
    //HERE it is Anything that you need to access for user
    NSLog(@"Country Name: %@", [userData objectForKey:@"CountryName"]);
    NSLog(@"Chosen Country Name: %@", [userData objectForKey:@"ChosenCountryName"]);
    NSLog(@"Country Code: %@", [userData objectForKey:@"CountryCode"]);
    NSLog(@"Police Number: %@", [userData objectForKey:@"Police"]);
    NSLog(@"Fire Number: %@", [userData objectForKey:@"Fire"]);
    NSLog(@"Hospital Number: %@", [userData objectForKey:@"Hospital"]);
    NSLog(@"Contact Person Full Name: %@", [userData objectForKey:@"EmergencyContactPersonFullName"]);
    NSLog(@"Contact Person Last Name: %@", [userData objectForKey:@"EmergencyContactPersonFirstName"]);
    NSLog(@"Contact Person First Name: %@", [userData objectForKey:@"EmergencyContactPersonLastName"]);
    NSLog(@"Contact Person Number: %@", [userData objectForKey:@"EmergencyContactPersonNumber"]);
    //NSLog(@"Contact Person UIImage: %@", [userData objectForKey:@"EmergencyContactPersonImageData"]);
    NSLog(@"Emergency Message: %@", [userData objectForKey:@"EmergencyMessage"]);
    NSLog(@"Current Location: %@", [userData objectForKey:@"CurrentLocation"]);
```
