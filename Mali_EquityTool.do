/* 
Nirali Chakraborty
June 11, 2019
Filename: Mali_EquityTool

Create equity tool for Mali, based upon the full wealth index we created

Compare output with Kenzo's work before moving forward

First run ET_ML_createMICSindex.do
*/


clear
capture log close
set more off

cd "/Users/Nirali_work/Documents/Equity Tool/Mali/"

log using "Mali_ET.log", replace

use "Mali_WI.dta", clear

/*Weight variables: 
gen hhmemwt=HH11*hhweight
gen double hhmemwtkap=int(hhmemwt*1000000)
*/

*generate grouped quintile variables: 2, 1, 2

recode WI_URB_1  (1/2=1) (3=2) (4/5=3), generate (urbDHS212)
recode WI_NAT_1 (1/2=1) (3=2)  (4/5=3), generate (natDHS212)

*!! generate starting factor-weighted asset variables, copy and paste code from do file generator

* Missing values were set to the mean during PCA. Now, values not equal to 1 are set to 0

/* From National, use following: Wood fuel, Chair, Earth/Sand floor, Bed, Television, Table, Electricity, Mobile Telephone
Has soap in hh, Water less than 30 min away.

From Urban, add in following: Fan, Cupboard, Owns bank account, CD/DVD player
*/

replace HC6_8=0 if HC6_8!=1
replace HC8I=0 if HC8I!=1
replace HC3_1=0 if HC3_1!=1
replace HC8J=0 if HC8J!=1
replace HC8C=0 if HC8C!=1
replace HC8H=0 if HC8H!=1
replace HC8A=0 if HC8A!=1
replace HC9B=0 if HC9B!=1
replace soap=0 if soap!=1
replace watloc_3=0 if watloc_3!=1
replace HC8K=0 if HC8K!=1
replace HC8R=0 if HC8R!=1
replace HC15=0 if HC15!=1
replace HC8F=0 if HC8F!=1

recode HC6_8 (0=0.316052529160365) (1=-0.101465966053627) , generate (HC6_8_nat)
recode HC8I (0=-0.231980987145626) (1=0.0692526193624051) , generate (HC8I_nat)
recode HC3_1 (0=0.193690363785608) (1=-0.142569327069467) , generate (HC3_1_nat)
recode HC8J (0=-0.184442184290127) (1=0.140772348941269) , generate (HC8J_nat)
recode HC8C (0=-0.172329743469783) (1=0.26558402469359) , generate (HC8C_nat)
recode HC8H (0=-0.168099992804455) (1=0.152971275727803) , generate (HC8H_nat)
recode HC8A (0=-0.171174508079201) (1=0.254512793487455) , generate (HC8A_nat)
recode HC9B (0=-0.225676420623674) (1=0.0263558987890675) , generate (HC9B_nat)
recode soap (0=-0.136131964896186) (1=0.151285200404598) , generate (soap_nat)
recode watloc_3 (0=0.137700942229485) (1=-0.0963688768519626) , generate (watloc_3_nat)
recode HC8K (0=-0.124532466465495) (1=0.389506259596416) , generate (HC8K_nat)
recode HC8R (0=-0.121738725918699) (1=0.454972286362608) , generate (HC8R_nat)
recode HC15 (0=-0.109485155147638) (1=0.324664898039423) , generate (HC15_nat)
recode HC8F (0=-0.107652143821505) (1=0.354065484252967) , generate (HC8F_nat)

recode HC8A (0=-0.391954009057669) (1=0.0954722983972512) , generate (HC8A_urb)
recode HC8C (0=-0.343662278023605) (1=0.103732176945748) , generate (HC8C_urb)
recode HC8J (0=-0.376209563321339) (1=0.0634586011539547) , generate (HC8J_urb)
recode HC8R (0=-0.266838147717578) (1=0.173217571029187) , generate (HC8R_urb)
recode HC8K (0=-0.240125972042859) (1=0.162022733278969) , generate (HC8K_urb)
recode HC8H (0=-0.248242060084065) (1=0.0827473533613549) , generate (HC8H_urb)
recode HC8I (0=-0.388820106901653) (1=0.0241185354690675) , generate (HC8I_urb)
recode HC15 (0=-0.175558400042189) (1=0.15405349029219) , generate (HC15_urb)
recode soap (0=-0.205286998662163) (1=0.0625477684069274), gen (soap_urb)
recode HC8F (0=-0.164598678733211) (1=0.176679320929861), gen (HC8F_urb)
recode HC9B (0=-0.375205840423385) (1=0.013056623921313), gen (HC9B_urb)
recode HC6_8 (0=0.0942155954686376) (1=-0.166647692059999), gen (HC6_8_urb)
recode HC3_1 (0=0.0859707772502808) (1=-0.241260331016911), gen (HC3_1_urb)
recode watloc_3 (0=0.0681618377724138) (1=-0.116513626152904), gen (watloc_3_urb)

*!! generate natscore, urbscore, natquintile, urbquintile, and 212 variables

egen double natscore_1 = rowtotal (*_nat)
egen double urbscore_1 = rowtotal (*_urb) if HH6==1
xtile natquintile_1 = natscore_1 [pweight = hhmemwt], nq(5)
xtile urbquintile_1 = urbscore_1 [pweight = hhmemwt] if HH6==1, nq(5) 
recode natquintile_1 (3=2) (1/2=1) (4/5=3), generate (nat212_1)
recode urbquintile_1 (3=2) (1/2=1) (4/5=3), generate (urb212_1)

*!! Set up putexcel

putexcel set "kappa.xlsx", sheet(1) modify
putexcel A2 = ("National") A10 = ("Urban") I2= ("212 Stats")

*!! *** variables

tabulate WI_NAT_1 natquintile_1 [aweight = hhmemwt], cell matcell(nat_freq)
local n =r(N)
matrix nat_perc = nat_freq/`n'
putexcel B3 = matrix(nat_perc)

tabulate WI_URB_1 urbquintile_1 [aweight = hhmemwt] if HH6==1, cell matcell(urb_freq)
matrix urb_perc = urb_freq/`n'
putexcel B11 = matrix(urb_perc)


kap WI_NAT_1 natquintile_1 [freq = hhmemwtkap]
kap natDHS212 nat212_1 [freq = hhmemwtkap]
putexcel I3 = rscalarnames J3 = rscalars

kap WI_URB_1 urbquintile_1 [freq = hhmemwtkap]
kap urbDHS212 urb212_1 [freq = hhmemwtkap]
putexcel I11 = rscalarnames J11 = rscalars

*National Kappa = 0.71, Urban Kappa = 0.56
*Add 5 variables from Urban side: Satellite dish, Radio, Motorcycle, Charcoal fuel, Water in own dwelling

replace HC9D = 0 if HC9D!=1
replace HC8B = 0 if HC8B!=1
replace HC8S = 0 if HC8S!=1
replace watloc_1 = 0 if watloc_1!=1
replace HC6_7 = 0 if HC6_7!=1

recode HC9D (0=-0.115980192017894) (1=0.097136554586326) , generate (HC9D_nat)
recode HC8B (0=-0.111512522599266) (1=0.0416731280353989) , generate (HC8B_nat)
recode HC8S (0=-0.101387974810007) (1=0.382907501899944) , generate (HC8S_nat)
recode watloc_1 (0=-0.0919778993319428) (1=0.283656779206059) , generate (watloc_1_nat)
recode HC6_7 (0=-0.0897962737638353) (1=0.35774653833145) , generate (HC6_7_nat)

recode HC8S (0=-0.159223886870194) (1=0.204394545803466) , generate (HC8S_urb)
recode HC8B (0=-0.16123952704537) (1=0.0463571347539575) , generate (HC8B_urb)
recode HC9D (0=-0.1387794886957) (1=0.0725693207147028) , generate (HC9D_urb)
recode HC6_7 (0=-0.131760104413654) (1=0.0992461062736929) , generate (HC6_7_urb)
recode watloc_1 (0=-0.120774938212638) (1=0.101829851946857) , generate (watloc_1_urb)

*!! generate natscore, urbscore, natquintile, urbquintile, and 212 variables

egen double natscore_2 = rowtotal (*_nat)
egen double urbscore_2 = rowtotal (*_urb) if HH6==1
xtile natquintile_2 = natscore_2 [pweight = hhmemwt], nq(5)
xtile urbquintile_2 = urbscore_2 [pweight = hhmemwt] if HH6==1, nq(5) 
recode natquintile_2 (3=2) (1/2=1) (4/5=3), generate (nat212_2)
recode urbquintile_2 (3=2) (1/2=1) (4/5=3), generate (urb212_2)

*!! Set up putexcel

putexcel set "kappa.xlsx", sheet(2) modify
putexcel A2 = ("National") A10 = ("Urban") I2= ("212 Stats")

*!! *** variables

tabulate WI_NAT_1 natquintile_2 [aweight = hhmemwt], cell matcell(nat_freq)
local n =r(N)
matrix nat_perc = nat_freq/`n'
putexcel B3 = matrix(nat_perc)

tabulate WI_URB_1 urbquintile_2 [aweight = hhmemwt] if HH6==1, cell matcell(urb_freq)
matrix urb_perc = urb_freq/`n'
putexcel B11 = matrix(urb_perc)


kap WI_NAT_1 natquintile_2 [freq = hhmemwtkap]
kap natDHS212 nat212_2 [freq = hhmemwtkap]
putexcel I3 = rscalarnames J3 = rscalars

kap WI_URB_1 urbquintile_2 [freq = hhmemwtkap]
kap urbDHS212 urb212_2 [freq = hhmemwtkap]
putexcel I11 = rscalarnames J11 = rscalars

*National Kappa 0.76, Urban Kappa 0.56
*Add in 5 more variables from Urban side; if no increase in Kappa, switch to Urban/Rural split
*Adding Watch, Brick walls, Refrigerator, Cement Roof, Piped into dwelling

replace HC9A = 0 if HC9A!=1
replace HC5_12 = 0 if HC5_12!=1
replace HC8E = 0 if HC8E!=1
replace HC4_13 = 0 if HC4_13!=1
replace WS1_1 = 0 if WS1_1!=1

recode HC9A (0=-0.0884921223850756) (1=0.0782223565174867) , generate (HC9A_nat)
recode HC5_12 (0=-0.0776505612633725) (1=0.212194084970826) , generate (HC5_12_nat)
recode HC8E (0=-0.0688132639467013) (1=0.576536185155477) , generate (HC8E_nat)
recode HC4_13 (0=-0.0603956680266638) (1=0.497445863665799) , generate (HC4_13_nat)
recode WS1_1 (0=-0.0579961612755706) (1=0.46225188056293) , generate (WS1_1_nat)

recode HC9A (0=-0.121805184510447) (1=0.0719056338101617) , generate (HC9A_urb)
recode HC5_12 (0=-0.116154867025691) (1=0.104487223608489) , generate (HC5_12_urb)
recode HC8E (0=-0.125598793752981) (1=0.286180603546827) , generate (HC8E_urb)
recode HC4_13 (0=-0.105338457533477) (1=0.253648152452002) , generate (HC4_13_urb)
recode WS1_1 (0=-0.0922363952845468) (1=0.18309004667346) , generate (WS1_1_urb)

*!! generate natscore, urbscore, natquintile, urbquintile, and 212 variables

egen double natscore_3 = rowtotal (*_nat)
egen double urbscore_3 = rowtotal (*_urb) if HH6==1
xtile natquintile_3 = natscore_3 [pweight = hhmemwt], nq(5)
xtile urbquintile_3 = urbscore_3 [pweight = hhmemwt] if HH6==1, nq(5) 
recode natquintile_3 (3=2) (1/2=1) (4/5=3), generate (nat212_3)
recode urbquintile_3 (3=2) (1/2=1) (4/5=3), generate (urb212_3)

*!! Set up putexcel

putexcel set "kappa.xlsx", sheet(3) modify
putexcel A2 = ("National") A10 = ("Urban") I2= ("212 Stats")

*!! *** variables

tabulate WI_NAT_1 natquintile_3 [aweight = hhmemwt], cell matcell(nat_freq)
local n =r(N)
matrix nat_perc = nat_freq/`n'
putexcel B3 = matrix(nat_perc)

tabulate WI_URB_1 urbquintile_3 [aweight = hhmemwt] if HH6==1, cell matcell(urb_freq)
matrix urb_perc = urb_freq/`n'
putexcel B11 = matrix(urb_perc)


kap WI_NAT_1 natquintile_3 [freq = hhmemwtkap]
kap natDHS212 nat212_3 [freq = hhmemwtkap]
putexcel I3 = rscalarnames J3 = rscalars

kap WI_URB_1 urbquintile_3 [freq = hhmemwtkap]
kap urbDHS212 urb212_3 [freq = hhmemwtkap]
putexcel I11 = rscalarnames J11 = rscalars

*National Kappa = 0.76, Urban kappa = 0.60.  There is poor differentiation in middle of distribution. 

