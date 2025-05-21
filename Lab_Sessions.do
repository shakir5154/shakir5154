
	/* 
	Author: Shakir Ullah Shakir
	Date: NA
	Purpose: ECON-532 LAB
	Last Updated: 
	 
	*/

	clear all
	set more off
	mat drop _all
	
	* Add switch here - We will do this later.

	* Method 1: Use full path (SHIFT Right click to copy as path)
		
	* 1a. Load Data: Excel File 

	import excel "C:/Users/IST/Dropbox/ECON532-Spring2025-Shared/00 Datasets/01 Excel Files/intro_excel.xlsx", sheet("Sheet1") firstrow

	* Let's load another excel file

	*import excel "C:/Users/IST/Dropbox/ECON532-Spring2025-Shared/00 Datasets/01 Excel Files/intro_excel.xlsx", sheet("Sheet1") firstrow

	* Shows an error - why? 

	* Use clear
	import excel "C:/Users/IST/Dropbox/ECON532-Spring2025-Shared/00 Datasets/01 Excel Files/intro_excel.xlsx", sheet("Sheet1") firstrow clear

	* 1b. Load Data: CSV File
	import delimited "C:/Users/IST/Dropbox/ECON532-Spring2025-Shared/00 Datasets/02 CSV Files/nearByGoogleAPI_hbl.csv", varnames(1) clear 

	* 1c. Load Data: Stata file 
	use "C:/Users/IST/Dropbox/ECON532-Spring2025-Shared/00 Datasets/00 DTA Files/PSLM 18-19/roster.dta", clear

	* Let's load another stata dataset
	use "C:/Users/IST/Dropbox/ECON532-Spring2025-Shared/00 Datasets/00 DTA Files/PSLM 18-19/sec 1a.dta", clear

	* Method 2: Change Directory 
	pwd
	* Present Working Directory

	* cd - change directory
	cd "~/Dropbox/ECON532-Spring2025-Shared/00 Datasets/01 Excel Files"
	pwd

	import excel "intro_excel.xlsx", sheet("Sheet1") firstrow clear

	* Method 3: Global method

	global dataSets "~/Dropbox/ECON532-Spring2025-Shared/00 Datasets"
	import excel "$dataSets/01 Excel Files/intro_excel.xlsx", sheet("Sheet1") firstrow clear
	use "$dataSets/00 DTA Files/PSLM 18-19/roster", clear

	* Method 4: ../ method
	pwd
	cd "C:/Users/IST/Dropbox/ECON532-Spring2025-Shared/03 ForStudents/Saqib_Ali_23160002/01 DoFile"

	cd "../../../00 Datasets/00 DTA Files"
	pwd
	use bro_edu_1, clear

	* Good Practices
	* Use global methods with username
	* Make folders for outputs i.e. tables and images

	di c(username)

	if c(username) == "Rabia" {
	di in red "Test"
	}

	if c(username) == "Rabia" {
	global DATA "C:/Users/IST/Dropbox/ECON532-Spring2025-Shared/00 Datasets"
	global tables "C:/Users/IST/Dropbox/ECON532-Spring2025-Shared/04 Tables"
	global figures "C:/Users/IST/Dropbox/ECON532-Spring2025-Shared/05 Images"
	}

	macro list

	/*
	if c(username) == "Your name" {
	global DATA "Your Data path"
	}
	*/
	
	* Unique Identification command: isid
	use "$DATA/00 DTA Files/PSLM 18-19/sec 1a", clear
	isid hhcode idc

	* Duplicates list and drop
		
	duplicates list hhcode idc

	* Example: Load Household level data
	use "$DATA/00 DTA Files/PSLM 18-19/sec_5a", clear
	duplicates list hhcode
	isid hhcode

	****************** LAB 2
	use "$DATA/00 DTA Files/PSLM 18-19/sec 1a", clear
	isid hhcode idc

	* Some Basics - Refresher 
						
	describe
	codebook hhcode
	codebook province

	drop if province == 7 | province == 8

	* Dsitribution of Variables?
	sum age, d

	* Open help and quickly look at scalars

	summ region
	d region
	d region
	label list region
	tab region, nolab

	* Finding age by region
	summ age if region == 2
	summ age if region == 1
	summ age

	bysort region: summ age

	tabstat age, by (region)
	tabstat age, by (region) stat (mean sd min max)
																* Explore options

	table region province s1aq04, c(mean age)

	* Variable Generation

	gen text = "ECONO"
	gen number = 1

	d s1aq04
	label list s1aq04
	* Is this a dummy variable?
	
	* TASK: Make a female dummy (Two methods)

	gen female = (s1aq04 == 2)
	tab female

	gen female_1 = 1 if s1aq04 == 2
	tab female_1
	replace female_1 = 0 if s1aq04 == 1

	assert female == female_1

	* Variable Label
	lab variable female "Female Dummy"
	tab female
				
	* Value Label
	lab define female 1 "Female" 0 "Male"
	lab val female female
	tab female




	/************************************************
		VARIABLE GENERATION, GEN, EGEN AND BYSORT
	*************************************************/	
		
		
	use "$DATA/00 DTA Files/PSLM 18-19/sec 1a", clear
	isid hhcode idc
		
	* == ~= != >= <= & |
		
	drop if province == 7 | province == 8
		
	tab province
	describe province
	label list province

		
		
	* Make Provinces Dummies
	tab province, gen(province_)
	br province*
	tab1 province*
		
		
	* Make HH Size Variables
	* First Think of a Logic
		
	* Method 1
	bysort hhcode: gen hhsize = _N
	lab var hhsize "HH Size"
			
	* Method 2
	bysort hhcode: egen hhsize_1 = count(idc)
			
	* Method 3
	egen hhsize_2 = count(hhcode), by(hhcode)

	egen tag_hhcode = tag(hhcode)	
	summ hhsize if tag_hhcode == 1
	tab tag_hhcode

		
	/*
	More Variables to make: 
		1. No of Children under 18
		2. No of Elders above and including 60 years 
		3. Female Household Head
		4. No. of Females in each house
	*/
		
	/******************************************
					VARIABLE TRANSOFRMATIONS
	******************************************/	
	
	describe province
	br province* hhcode* age

	* red, Blue, Black
	decode province, gen(province_dec)
	* removes code/numeric label and returns string

	tostring province, gen (pro)
	* converted the numeric value into string

	tostring hhcode, gen(hhcode_s)
	encode province_d, gen(province_en)
		
	d province*
	label list province
	label list province_en
	* Takes Alphabetical Order, check their labels and discuss
						
	destring hhcode_s, gen (hhcode_ds)
	isid hhcode idc
		
		
	/**********************************************
						MERGING
	***********************************************/	

	use "$DATA/00 DTA Files/PSLM 18-19/sec_2ab", clear	
	count
	d
	tab1 s2aq01 s2aq02, nolab
	gen literacy = (s2aq01 == 1 | s2aq02 == 1)
			
	lab var literacy "Can read or write"
	pwd

	* This file is ready to merge - so you either place it in the working Data 
	* folder or save it as a tempfile
			
	* save "$workingData/merge", replace		
	tempfile usingData
	save `usingData'
		
	use "$DATA/00 DTA Files/PSLM 18-19/sec 1a", clear
	count
	tab age
	
	* roster data, 175,690 obs
	* education data, 147,714 obs	
			
	* correspondence
	* variables
	* using dataset
		
	merge 1:1 hhcode idc using "$workingData/merge" 
		
	* master vs using 
	* look/scrutinize obs that get matched and not 
		
	* Other useful commands
		
	* Merge using tempfile, and generating m1 instead of default _merge
	*merge 1:1 hhcode idc using `usingData', gen(m1)
		
	* Merge using tempfile, and not generating any merge variable
	*merge 1:1 hhcode idc using `usingData', nogen
		
	/* Sample code: drops _merge every time a new merge is done
	merge 1:1 hhcode idc using `usingData1'
		
	cap drop _merge
	merge 1:1 hhcode idc using `usingData2'

	cap drop _merge
	merge 1:1 hhcode idc using `usingData3'
	*/
		
	* Many to 1 Merge 
	* merge roster with 5a
		
	cap drop _m
	merge m:1 hhcode using "$DATA/00 DTA Files/PSLM 18-19/sec_5a"
		
	tab literacy if _m == 1
		
	* Now we can find literacy rates by gender
	tabstat literacy, by(s1aq04)
		
			
	/*****************************************
							APPENDING
	******************************************/	

		
	use "$DATA/00 DTA Files/PSLM 18-19/sec_2ab", clear	
	count
	d
	tab1 s2aq01 s2aq02, nolab
	gen literacy = (s2aq01 == 1 | s2aq02 == 1)
			
	lab var literacy "Can read or write"		
	keep hhcode province region idc literacy 
	gen year = "2018-19"
		
	tempfile 201819
	save `201819'
			
	use "$DATA/00 DTA Files/sec_c_2010_11", clear
		
	gen literacy = (Scq01 == 1)
	tab literacy
	lab var literacy "Literate"
	keep hhcode Province Region idc literacy
	gen year = "2010-11"	
	rename (Province Region) (province region)
		
	append using `201819'
	count
		
	tabstat literacy, by(year)

	**************************************************************
	*				LONG to WIDE and VICE VERSA
	**************************************************************
		
	global main "~/Dropbox/Madrassa_DataWork/00 Dataset"

	* Lets merge income and expenditure section
	* Motivate: m:m situation so let's reshape

	* Essentials

	* 1. Long to Wide or Wide to Long?
	* 3. Which variable to move from long to wide OR wide to long
	* 2. Arguments: i and j
	* 4. 
	*	a. Long to Wide: 
	*	i (variable where data SHOULD be unique/YOU want your data to be unique AFTER reshape) 
	*	 j(stub: variable that gets attached/goes with from long to wide)
	*	 j should be unique in i




	*	b. Wide to Long: i(data is CURRETLY unique at)	
	* Rename reshape variable to reshape_ becaause j is going to be attached to it


	* Long to Wide
	use "$DATA/00 DTA Files/PSLM 18-19/sec_6a", clear
	count
	isid hhcode itc
	egen total_exp_item = rowtotal(v*)
	drop q*

	* Lets only keep water and electricity charges
	keep if inlist(itc, 044101, 45101)

	rename total_exp_item total_exp_item_

	drop v*

	count

	codebook hhcode

	reshape wide total_exp_item_, i(hhcode) j(itc)
	isid hhcode
	count




	* Wide to Long
	* j: A new variable is constructed

	use "$main/00_all_sections_do_files/bro_edu_wide", clear

	codebook instanceID

	keep bro_age_* bro_school_rank_* instanceID

	reshape long bro_age_ bro_school_rank_, i(instanceID) j(bro_count)

	isid instanceID bro_count

	/*
	* Overview of Useful String Commands
	* charlist
	* strpos: can be used to pick certain string characters and replace/find etc	
	* subinstr: can be used to replace certain characters 
	* trim, itrim, proper, upper, lower: adjusts spaces, and case
	* tostring, destring
	* split, parse
	*/


	* Files to Clean- 
	* 1. district variable
	 
	use "$DATA/00 DTA Files/data_cleaning_set", clear
	 
	rename district_22020491  district

	clonevar district_tbc = district

	* strpos 
	replace district_tbc = "Punjgur" if strpos(district_tbc, "Panjgur")
	 
	replace district_tbc = "Bwpr" if strpos(district_tbc, "Bahawalpur")

	replace district_tbc = "Vhri" if strpos(district_tbc, "Vehari")

	replace district_tbc = "KA" if strpos(district_tbc, "Killa")


	replace district_tbc = "NF" if strpos(district_tbc, "Feroze")

	* subinstr

	clonevar district_2 = district

	tab district

	replace district_2 = subinstr(district_2,  "11", "", .)

	replace district_2 = subinstr(district_2,  "~", "", .)

	replace district_2 = subinstr(district_2,  "!", "", .)

	replace district_2 = subinstr(district_2,  "(:", "", .)

	replace district_2 = subinstr(district_2,  ":)", "", .)

	replace district_2 = subinstr(district_2,  ":P", "", .)

	replace district_2 = subinstr(district_2,  ":D", "", .)

	replace district_2 = subinstr(district_2,  ":*", "", .)

	replace district_2 = subinstr(district_2,  "--", "", .)

	replace district_2 = trim(itrim(district_2))

	 
	 
	 
	*2. district variable
	 import delimited "C:\Users\IST\Dropbox\ECON532-Spring2025-Shared\00 Datasets\02 CSV Files\nearByGoogleAPI_hbl.csv", varnames(1) clear 

	 split geometry, parse(":")
	 
	 drop geometry1 geometry2
	
	 
	split geometry, parse(":")
	drop geometry1 geometry2
	replace geometry3 = subinstr(geometry3, "'lng'", "", . )
	replace geometry3 = subinstr(geometry3, ",", "", . )
	replace geometry3 = trim(itrim(geometry3))

	drop geometry1 geometry2
		
		
	
	global main "~/Dropbox/Madrassa_DataWork/00 Dataset"

	/*
	display command, scalars, locals vs globals, types of commands, 
	*/
		
	* di
		
	* Diplay anything
	di "My name is Rabia"
		
	* Di as a calculator
	di 2+2
	di 200*3
		
	* Taking input from the terminal -- Here, name is like a global
	di "whats my name?", _request(name)						
	di "$name"
		
	di "whats my age?", _request(age)	
	di $age
	di "$age"
		
	macro list
	* Whatever you type in the commmand window, will be stored in $name global
	* NOTE, how you can recall the stored global (text or not)
		
	* Scalars: Programming variables: 
	*	can store values
	*	can be used in calculations efficiently
	* 	active as long as stata session is on
	* 	value gets override if you do 
		
		
	* Defining Scalars:
	scalar x = 2
	scalar y = "Hello Stata!!!"

	scalar list
	scalar drop _all
			
	* Types of Commands: r-class, e-class, c-class, s-class		
	* r class -- regular class - return list
	* e class -- estimation class - e-return list
	* s class -- system class command
	* c class -- stata settings, current date is quite useful
	* i.e. `c(current_date)'

	* rclass
	sysuse auto, clear
		
	summ price, d
	return list
		
	di r(mean)
	di "`r(mean)'"
	di "The mean of Price is r(mean)"
	di "The mean of Price is `r(mean)'"
		
	* eclass
	reg price weight mpg
	return list
	ereturn list
	sreturn list
	mat list e(b)
		
	* e(b) is the matrix of coefficients
	* You can use the scalars stored in the return/ereturn list etc
	* Instead of making variable, sometimes it is more convenient to make scalars
		
	/* 
	
	TASK 1: 
	Store the mean of price in scalar called mean_p and mean of weight in scalar called mean_w. 
	Now define a scalar that stores their difference. Verify calculation through the di command.
	
	*/
				
	sysuse auto, clear
	summarize price, meanonly
	di r(mean)
	scalar mean_p = r(mean)			// Stroing the mean of price in scalar called m1
	summarize weight, meanonly
	di r(mean)
	scalar mean_w = r(mean)			// Stroing the mean of weight in scalar called m2
	scalar df = mean_p - mean_w		// Storing the difference of m1 and m2 in df
		
	scalar list					// displaying all the scalars
		
	* Local vs Globals
		
	* `' to call local - color change as well
	* "" if its a string
	* Local stays active if its made and run in the same go 
	* global, on the other hand has a longer life- till your stata 
	* session is active
	* $ to call global
		
	local vars price weight trunk
	di `vars'
	di "`vars'"
		
	local vars "price weight trunk"
	di `vars'
	di "`vars'"
		
	* Note the difference in how you call components of local
		
	global test price weight trunk
	di $test
	di "$test"
	macro list
		
	* Loops Basic Structure
	* Local, global, varlist, 
	sysuse auto, clear
	foreach x of varlist price foreign trunk {
		di in red "`x'"
	}
		
	local a abc def xyz
	foreach x of local a {
		di in red "`x'"
	}
		
	local a "1 2 3"
	foreach x of local a {
		di in red `x'
	}
		
		
	global vars make price mpg rep78 headroom trunk weight length turn
	foreach i of global vars {
		di in red "`i'"
	}
		
			
	macro list 
		
	foreach var of varlist make-gear_ratio{
		di "`var'"
	}
		
	* For varlist, X acts as a local
	for varlist price mpg: egen mean_X = mean(X)
		
	forvalues n = 1/20{
		di in red `n'
	}
		
	forvalues n = 1 (5) 20{
		di in red `n'
	}
		
	forvalues n = 1 (2) 10{
		di in red `n'
	}
		
		
	* Nested loops
	forvalues i = 1/10 {
		foreach x of varlist price make trunk {
			di in red "`x', `i'"
		}
	}
			
	* Now swap loops
	foreach x of varlist price make trunk {
		forvalues i = 1/10 {
			di in red "`x', `i'"
		}
		}
		
	* Lets say we want an index with increment of one
	local j = 0
	foreach x of varlist price make trunk {
		di in red "`x', index -- `j'"
			local ++j
		}
			
	* Lets say we want an index with different increment	
	pause on
	local j = 1000
	foreach x of varlist price make trunk {
		di in red "`x', index -- `j'"
			local j = `j' + 2
			
		}	
		
	* pause on
	* How does pause work
	* type q in the command window, BREAK, pause off
			
		
			
		
		
	* HW TASKS

	/*
	1. Display even numbers in green, odd numbers in red [Hint: mod]mod(\i', 2)`mod(a, b) gives the remainder when a is divided by b.
	mod(i', 2)checks ifi` is even or odd:

	If mod(i, 2) == 0 → i is even (no remainder).

	If mod(i, 2) == 1 → i is odd.
		
	*/
		
	/*
	
	2. takes the input from the terminal using myrequest and displays a table 
	f 2 if you give 2 as input and displays a table of 3 if you give 3 as input!
	*/

	/*		
	3. renames the variables in data with your rollnmber and a random english alphabet. eg: price_15050014_s
	*/
	/*			
	4. Save your do file with current date local in file name
	5. Standardise price, length, weight, mpg in a loop. Then verify they are standardised correctly.

	Feed values into loop via (i) local (ii) global (iii) varlist
		Notice the difference and similarities.
		
	*/
	
	* Some further loop applications
		
	* Calling and appending and cleaning files in a single loop	
		
	* Data Cleaning in a loop
		
		
	* Running regression in a loop
		
		
	global main "~/Dropbox/Madrassa_DataWork/00 Dataset"

		
	* 1. Data Cleaning in Loop - Removing Characters

	use "$DATA/00 DTA Files/data_cleaning_set", clear
	tab district_22020491
	rename district_22020491 district 
	clonevar district_tbc = district
	charlist district_tbc
	tab district_tbc
	local chars "! () - 11 :P ~ (  ) * :D :"
	foreach x of local chars {
		replace district_tbc = subinstr(district_tbc, "`x'", "", .)
		}
		
	tab district_tbc
		
	replace district_tbc = trim(itrim(proper(district_tbc)))
		


	* 2. Data Cleaning in Loop
		
	* Line 662 - 725 (Madrassa Work)

	* 3. Calling, Cleaning and Appending Files in Loop
		
	cd "$XSL"
	pwd
	dir	
		
		
	import excel "KHAIRPUR SAT VI RESULT.xlsx", sheet("KHAIRPUR") cellrange(A1:R22993) firstrow clear	


	foreach file in "KHAIRPUR" "LARKANA" {
		di "`file'" 

		import excel "`file' SAT VI RESULT.xlsx", sheet("`file'") firstrow clear

		count
		drop in 1
	}

	* Problems: Gend., % 
	* Problem - we want entry in first row to be used as variable name
		* - drop in 1
		* - Fix G and %
		* 	Drop R
		

	foreach file in "KHAIRPUR" "LARKANA" {
		di "`file'" 
		import excel "`file' SAT VI RESULT.xlsx", sheet("`file'") firstrow clear
		count
		drop in 1
		replace G = "Gender" if strpos(G, "Gend")
		replace Q = "percent" if Q == "%"
		drop R
		br
	}	


		clear all
		tempfile master
		save `master', emptyok
		
		foreach file in "KHAIRPUR" "LARKANA"{
			di "`file'"
			import excel "`file' SAT VI RESULT.xlsx", sheet("`file'") firstrow clear
			// removing fist row
			drop in 1
			// dropping unnecessary variable
			drop R
			replace G = "Gender" if strpos(G, "Gend")
			replace Q = "percent" if Q == "%"
			
			foreach var of varlist _all{
				local x = `var' in 1
				local y = proper("`x'")
				local z = subinstr("`y'", " ", "",. )
				local p = subinstr("`z'", ".", "",. )
				di "`p'"
				ren `var' `p'
			}
			
			drop in 1
			destring *, replace
			
			gen district = "`file'"
			
			append using `master'
			sa `"`master'"', replace
					
		}
		
		tab district
		sa master, replace
		
		
	global main "~/Dropbox/Madrassa_DataWork/00 Dataset"

		
	* 1. Data Cleaning in Loop - Removing Characters

	use "$DATA/00 DTA Files/data_cleaning_set", clear
	tab district_22020491
	rename district_22020491 district 
	clonevar district_tbc = district
	charlist district_tbc
	tab district_tbc
	local chars "! () - 11 :P ~ (  ) * :D :"
	foreach x of local chars {
		replace district_tbc = subinstr(district_tbc, "`x'", "", .)
		}
		
	tab district_tbc
		
	replace district_tbc = trim(itrim(proper(district_tbc)))
		
	* 2. Data Cleaning in Loop
		
	* Line 662 - 725 (Madrassa Work)

	* 3. Calling, Cleaning and Appending Files in Loop
		
	cd "$XSL"
	pwd
	dir	
		
		
	import excel "KHAIRPUR SAT VI RESULT.xlsx", sheet("KHAIRPUR") cellrange(A1:R22993) firstrow clear	


	foreach file in "KHAIRPUR" "LARKANA" {
		di "`file'" 

	import excel "`file' SAT VI RESULT.xlsx", sheet("`file'") firstrow clear

	count
	drop in 1
	}

	* Problems: Gend., % 
	* Problem - we want entry in first row to be used as variable name
	* - drop in 1
	* - Fix G and %
	* 	Drop R
		

	foreach file in "KHAIRPUR" "LARKANA" {
		di "`file'" 
		import excel "`file' SAT VI RESULT.xlsx", sheet("`file'") firstrow clear
		count
		drop in 1
		replace G = "Gender" if strpos(G, "Gend")
		replace Q = "percent" if Q == "%"
		drop R
		br
	}	


		clear all
		tempfile master
		save `master', emptyok
		
		foreach file in "KHAIRPUR" "LARKANA"{
			di "`file'"
			import excel "`file' SAT VI RESULT.xlsx", sheet("`file'") firstrow clear
			// removing fist row
			drop in 1
			// dropping unnecessary variable
			drop R
			replace G = "Gender" if strpos(G, "Gend")
			replace Q = "percent" if Q == "%"
			
			foreach var of varlist _all{
				local x = `var' in 1
				local y = proper("`x'")
				local z = subinstr("`y'", " ", "",. )
				local p = subinstr("`z'", ".", "",. )
				di "`p'"
				ren `var' `p'
			}
			
			drop in 1
			destring *, replace
			
			gen district = "`file'"
			
			append using `master'
			sa `"`master'"', replace
					
		}
		
		tab district
		sa master, replace
		
	********************* Outreg2 - Basic Tables ********************
	sysuse auto, clear

	* This gives a basic summary table
			outreg2 using "$tables/ss_outreg2.rtf", sum(log)  ///
			keep(price mpg weight length)   				///	
			eqkeep(mean min max) 							///
			label replace


	* This gives a (basic) regression table - regress and outreg2
	reg price length
	outreg2 using "$tables/reg_outreg2.rtf", label replace

	* This ADDS regression table to the existing file if you need more outcomes 
	reg price length weight mpg i.foreign
	outreg2 using "$tables/reg_outreg2.rtf", label 
			
			
	* This gives a (basic) regression table - regress and outreg2 BUT shows ONLY main coefficient and adds text for controls
	reg price length
	outreg2 using "$tables/reg_outreg2_mod.rtf", label replace
			
	reg price length weight mpg i.foreign
	outreg2 using "$tables/reg_outreg2_mod.rtf", label ///		
			keep (length) addtext(Controls, YES)



	* Useful Options: nocons, label, keep, addtext

	* Some application of loops/gloabls 
			
	use "$DATA/00 DTA Files/sci_reg", clear
	global BABhera BA_dummy bhera_d
	global family parents_schooling wealth_index
	global family_rel parents_schooling wealth_index parents_higher_rel_ed

	cd "$tables"	
	foreach x of varlist sci_opt sci_res {
		di in red "`x'"
	reg `x' BA_dummy
	outreg2 using "`x'.rtf", replace nocons label addnote(Family Controls include Parents Formal Schooling, Parents Higher Religious Education and Wealth Index)
			
	reg `x' $BABhera
	outreg2 using "`x'.rtf", nocons label
			
	reg `x' $BABhera $family_rel
			outreg2 using "`x'.rtf", nocons label 
		}	

	 * Option: keep(BA_dummy bhera_d) addtext(Family Controls, YES)


	* Esttab 
	* Esttab  - Summary Stats Table

	sysuse auto, clear
		
	estpost summarize price mpg weight length 

	#delimit ;
			
	esttab using "$tables/ss_est.rtf", 
	cells("count min(fmt(0)) max (fmt(0)) mean(fmt(2)) sd(fmt(2))") 
	collabels(N Min Max Mean SD) 
	replace label 
	varwidth (35) modelwidth(5 5 7 9 9 9) 
	addnote(Note: Anything you want to add as note.) 
	nonumbers ti("Table Title here");
	#delimit cr

	* Esttab  - (Nice) Regression Tables

	* How to add scalar values in regression table? 
	* This is one model
		
	use "$DATA/00 DTA Files/sci_reg", clear
		
	estimates drop _all
			
	eststo clear
			
	eststo: reg sci_opt BA_dummy bhera_d parents_schooling parents_higher_rel_ed
			
	summ sci_opt
	return list
	estadd scalar sci_opt_mean = r(mean)
			
	estimates store sci_opt

		
	* Spcifying file name in a local
	cap drop 
	cap erase "$tables/reg_esttab.rtf"
	local filename = "$tables/reg_esttab.rtf"
			
	* Tabulate
	esttab sci_opt using "`filename'", ///
	se label b(%05.3f) se(%05.3f) r2(%05.3f)  star(* 0.10 ** 0.05 *** 0.01) ///
	title(Table: BA and Scientific Optimism Scores) ///
	scalars("sci_opt_mean Mean Sci Opt Score") ///
	noconstant nogaps addnotes("Scientific Optimism Score was calculated using WVS Indices.")
		
		
	* These are two models
		
		
	use "$DATA/00 DTA Files/sci_reg", clear
	estimates drop _all
	local science sci_opt sci_res
	foreach v of local science {
		di "`v'"
		eststo: reg `v' BA_dummy bhera_d parents_schooling parents_higher_rel_ed
		sum `v' 
		estadd scalar `v'_mean = r(mean)
			
		// This goes in esttab command
		estimates store `v'
			
		}
		
	* Spcifying file name in a local
		
	cap erase "$tables/reg_esttab_twomodels.rtf"
	local filename = "$tables/reg_esttab_twomodels.rtf"
		
	* Tabulate
	esttab `sci_opt' `sci_res' using "`filename'", se label b(%05.3f) se(%05.3f) r2(%05.3f)  star(* 0.10 ** 0.05 *** 0.01) ///
		title(Table: BA and Scientific Optimism Scores) ///
		scalars("sci_opt_mean Mean Sci Opt Score" "sci_res_mean Mean Sci Res Score") ///
		noconstant nogaps addnotes("Scientific Optimism and Reservation Score was calculated using WVS Indices.") 
	* Here, we dont need append option as we are calling individual estimates
		
	* OR 
		
	use "$DATA/00 DTA Files/sci_reg", clear
	estimates drop _all
	local science sci_opt sci_res mask_yes
	foreach v of local science {
		di "`v'"
		eststo: reg `v' BA_dummy bhera_d parents_schooling parents_higher_rel_ed
		sum `v' 
		estadd scalar `v'_mean = r(mean)
			
		// This goes in esttab command
		estimates store `v'
			
		}
		
	* Spcifying file name in a local
		
	cap erase "$tables/reg_esttab_twomodels_2.rtf"
	local filename = "$tables/reg_esttab_twomodels_2.rtf"
		
		
	* Tabulate
	esttab `science' using "`filename'", se label b(%05.3f) se(%05.3f) r2(%05.3f)  star(* 0.10 ** 0.05 *** 0.01) ///
		title(Table: BA and Scientific Optimism Scores) append ///
		scalars("sci_opt_mean Mean Sci Opt Score" "sci_res_mean Mean Sci Res Score") ///
		noconstant nogaps addnotes("Scientific Optimism and Reservation Score was calculated using WVS Indices.") 
				* Here, we NEED append option as we are NOT calling individual estimates- but rather local science	 
		
	
	************************** Randomization ********************************
	version 16
	set seed 41863487


	if c(username) == "Rabia" {
		global DATA "C:/Users/IST/Dropbox/ECON532-Spring2025-Shared/00 Datasets"
		global tables "C:/Users/IST/Dropbox/ECON532-Spring2025-Shared/04 Tables"
		global figures "C:/Users/IST/Dropbox/ECON532-Spring2025-Shared/05 Images"
		global workingData "C:/Users/IST/Dropbox/ECON532-Spring2025-Shared/00 Datasets/04 WorkingData"
	}

	/*
	* Some Preliminaries
	* Number or percentage? 
	Typing sample 5 without the count option means that a 5% sample be drawn; typing sample 5, count, however, would draw a sample of 5 observations.
			
	* Can be combined with 'if'
			
	* VERY IMPORTANT: set seed
	*/
			
			
	* 1. Drawing Sapmple
			
	import excel "$DATA\01 Excel Files\KHAIRPUR SAT VI RESULT.xlsx", sheet("KHAIRPUR") cellrange(A3:R22993) firstrow clear
	count	  
	* 22,990 obs
		  
	* Method 1: lets draw 20% sampple
	sample 20
	count
	*4,598 obs
		  
		  
	* Method 2: lets draw a sampple of 1000
	sample 1000, count
	count
		  
	* Method 3: runiform method
	gen rand = runiform()
	sort rand
	keep in 1/1000
		  
	* Sample by Taluka - maintains the proportion of the group
	sample 20, by(Taluka)
		   
	sample 1000, count by(Taluka)
	bys Taluka: sample 1000, count
		   
	// Stratified sample by Taluka and UC
	bys Taluka UC: sample 10, count
		   
		   
		   
		   

	  

	**************************************************
		 
	* 2. Randomization into Treatment and Controls
					
		  
	import excel "$DATA\01 Excel Files\KHAIRPUR SAT VI RESULT.xlsx", sheet("KHAIRPUR") cellrange(A3:R22993) firstrow clear
		 
		* runiform method - very important to shuffle observations
		gen rand = runiform()
		sort rand
		keep in 1/1000
		  
		* first - f, last - l
		cap drop treat
		gen treat = 1 in f/500
		  
		replace treat = 0 in 501/l
		  
		
		lab define treat 1 "Treatment" 0 "Control"
		lab val treat treat 
		tab treat
		  
		* Balance Checks - 1
		tabstat TOTALMATHS, by(treat)
		  
		* Balance Checks - 1
		ttest TOTALMATHS, by(treat)
		ttest TOTALSCIENCE, by(treat)
		   
		  
		**************************************************
		  
		* 3. preserve, restore
		  
		use "~\Dropbox\ECON532-Spring2025-Shared\00 Datasets\00 DTA Files\class_roster.dta", clear
		pwd
		d
		count
		preserve
		sample 5, count
		export excel using "sample", firstrow(variables) replace
		* export, table, graph - work with a subset 
		  
		restore
		count
		 
		* NOTICE what happens if we don't specify the seed
						
		***********************************************
		  
		* 4. Randomly making pairs
		* TASK: Use class_roster data to randomly make pairs of 2. 
		* Drop one observation and make 11 pairs. 
		  
		  
	*******************************************************************
	* 							WHY VISUALIZE?	 
	*******************************************************************
	global DATA "~/Dropbox/ECON532-Spring2025-Shared/00 Datasets"
	
	use "$DATA/00 DTA Files\viz_data2_lab1.dta", clear
		 
	* Correlation and linear regression -- quantify linear relationships between variables. 
	* Let us look at the relation between x1 and y1 y2 y3
		
	correlate x1 y1 y2 y3
		
	/* 
	* Scatterplots are popular for displaying the relationship between two continuous 
	* variables using only the raw data. Each point on the graph represents an observation. 
		
	* The position of each point is determined by the observation's values of the 
	* two continuous variables.
	*/
		
		
	scatter y1 x1, saving(y1x1.gph, replace) nodraw
	scatter y2 x1, saving(y2x1.gph, replace) nodraw
	scatter y3 x1, saving(y3x1.gph, replace) nodraw

	* The saving() option stores the visual physically on your drive however,
	
	* using the name() option saves it in temporary memory
		
	* scatter y1 x1, name(y1x2, replace)
		
	graph combine y1x1.gph y2x1.gph y3x1.gph	//Combines saved graphs together
	
	* Useful option: nodraw
		
	* Clearly there is a non-linear relation between the variables and that was
	
	* not being captured by the correlation matrix we saw earlier. This is why
	
	* solely relying on tables etc is not useful.
		
	/**********************************************
		Basic Visualisation/Parts of Graph, and 
		Saving/Exporting Graphs
	***********************************************/
		   
	sysuse auto, clear
	scatter price mpg, 											///
		 title(This is a title, color(orange) ring(0) position(1))	/// add a title 
		   subtitle(This is a subtitle, color(orange))  		/// add a subtitle
		   caption(This is a caption, color(orange))  			/// add a caption
		   note(This is a note, color(orange)) 					/// add a note
		   xtitle("This is the x-axis title", color(orange)) 	/// change the xtitle
		   ytitle("This is the y-axis title", color(orange)) 	/// change the ytitle
		   graphregion(color(gray)) 							///	see what is graph region				
	saving("$figures/fig1", replace)
		   
	* OR
		   
	save "$figures/fig2", replace
	graph export "$figures/fig3.png", width(500) height (600) replace 
		   

	* If filename is specified without an extension, .gph will be assumed.
		
	/***************************************************
	Basic Types of Graphs in Stata:
	One Way:	one variable (mean, frequency, etc.) 
			
	Two Way:	two variables OR
	two different graphs (e.g. scatter plot and line of best fit)
	Twoway graphs show the relationship between numeric data.
	**********************************************/	 
	
	sysuse auto, clear
	
	#delimit ;
	twoway 
	(
	scatter price mpg if price>5000, 
	mcolor(red) 
	msymbol(square) 
	mlcolor(red) 
	mfcolor(red)
	) 
	(
	scatter price mpg if price<=5000, 
	mcolor(gs6) 
	mfcolor(blue) 
	mlcolor(gs6)
	)
	, 

	legend(region(lcolor(none) fcolor(none)) size(2.5) order(2 1) position(4) col(1) label(1 Price>5k) label(2 Price<=5k)) 
	graphregion(color(white)) 
	xlabel(#2, grid glstyle(dot) glcolor(gs9) angle(45) labsize(2.5)) 
	xscale(noextend) 
	ylabel(, grid glstyle(dot) glcolor(gs9) angle(45) labsize(2.5)) 
	yscale(noextend) 

	title({bf}Scatterplot for Price and Mileage, size(4)) 
	subtitle("Prices above $5,000 are in red", size(3)) 

	note(Source: 1978 Automobile Data, size(1.75)) 
	caption(The visual combines clutter free scheme and colors to form a neat visual, size(1.75))

	;
	#delimit cr
		
	twoway (scatter mpg weight) (lfit mpg weight), scheme(economist)
		
	*************************************
	* Some Advanced Options
	************************************
		
	* Installing schemes and colorpalettes
			
	* A scheme specifies the overall look of the graph. 
	
	* Option scheme() specifies the graphics scheme to be used with this 
	
	* particular graph command without changing the default.

	* Styles define the features that are available to you.
			
	* To see available graph schemes and colorstyles
	graph query, scheme
	graph query colorstyle
		
	* Installing color palettes and schemes
	ssc install schemepack, replace
	ssc install colrspace, replace
	ssc install palettes, replace
			 
	* Examples
	twoway (scatter mpg weight) (lfit mpg weight), scheme(tab1)
	twoway (scatter mpg weight) (lfit mpg weight), scheme(tab2)
	twoway (scatter mpg weight) (lfit mpg weight), scheme(tab3)
	twoway (scatter mpg weight) (lfit mpg weight), scheme(modern)

		
	*************************************************
	* 					Graph Legends
	*************************************************
	
	#delimit ; 
	graph   pie, over(foreign)  
	legend(on  			/// display the legend
	 rows(1) 			/// display all categories in a single row
	stack 				/// stack the markers on top of the labels
	 size(medium)  		/// change font size to large
	color(navy) /// change font color to blue
		) 
	graphregion(color(black))
	; 
	#delimit cr
			
			
	#delimit ; 
	graph pie, over(foreign)  
	legend(on  				/// display the legend
		nostack  			/// do not stack the markers on top of the labels
						 cols(1)  				/// display legend categories in a single column
							size(medium)  			/// change the legend font size to medium large
						 color(navy)  			/// change the legend font color to navy
							margin(small) 			/// change the margin between the legend text and box to small
							region( 				/// display a box around the legend
							   fcolor(gs14)  	/// change the legend fill color to gray-scale 14
							   lcolor(gs4)  	/// change the legend box line color to green
							   lwidth(thick)  	/// change the legend box line width to thick
							   lpattern(solid)) /// change the legend box line pattern to solid
							title(Legend Title,	/// add a title to the legend  
							   size(large)  	/// change the legend title font size to large
							   color(orange))  	/// change the legend title font color to orange
					position(5)  					/// change the legend position to 5 o'clock
				 ring(0))						/// move the legend inside the plot region
					graphregion(color(black))
	; 
	#delimit cr
		
		
	/************************************************
	Understanding different graph types and suggested usage 
	************************************************/
		
	* Each command has options associated with it. Options are followed by the 
	* comma separator
		
	******************************************
	* Histograms
	******************************************
	* They are popular and useful but histograms can look quite different depending 
	* on the number of bins selected. Each bin is plotted as a bar whose height 
	* corresponds to how many data points are in that bin. 
	* Bins are also sometimes called "intervals", "classes", or "buckets"
		
	use "$DATA/00 DTA Files/viz_data1_lab1.dta", clear
	histogram weight, fcolor(green) lcolor(black) title(Histogram of weight)
		
	* OR (Options to explore/note: bin, frequency))
		 
	#delimit ;
	histogram weight, 		
		fcolor(green) 	
		lcolor(white) 	
		title(Histogram of weight)
		subtitle(Just a histogram example)
		note("A place to write our data source possibly", size(2))
		bin(5) frequency addlabel
	;
	#delimit cr
		
	**********************************************
	* 				BOXPLOTS
	***********************************************

	* Boxplots display information about various quantiles of a continuous variable. 
		
	* The line in the center of the box is the median, the outer edges of the 
		
	* box are the 25th and 75th percentiles, the "whiskers" are the lower- and 
		
	* upper-adjacent values, and the points outside that range are 
		
	* the outside values.
		
	graph box cholesterol
		
	* As mentioned previously, we can edit the graph using editor or using commands
		
	#delimit ;
	graph box cholesterol,
		box(1, fcolor(red)) 
		cwhisker 
		lines(lcolor(red))
		capsize(20)
		marker(1, mcolor(red))
	;
	#delimit cr
		
	*******************************************
	* 					PIECHART
	********************************************
	
	* When we create graphs for categorical variables, we are often interested in 
	
	* the frequency or the proportion of the sample that belongs to each category 
	
	* of the variable. Pie charts are often used for this purpose. 
	
	* The circle represents the total sample and each "slice" is proportional to 
	
	* the percentage of the sample that belongs to a category.

	graph pie, over(sex)
		
	* We can modify the appearance for this chart using:

	#delimit ;
	graph pie, over(sex) 
		pie(1, color(cranberry) explode(medium))
		pie(2, color(ltblue))
		plabel(_all percent, color(white))		//Options: sum, percent, name, "text"
		scheme(plotplain)
		;
	#delimit cr
		
	*********************************************
	* BAR CHARTS 
	*********************************************
	
	* Bar charts are another way of displaying the frequency or relative frequency 
	
	* of observations for categorical variables. 
		
	* The height of each bar is proportional to the count or percentage of 
	
	* observations in each category of the categorical variable.
		
	graph bar, over(race)
	
	* Default output here is percentage on the Y-Axis
		
	graph bar, over(race) 							///
	bar(1, fcolor(cyan) lcolor(gs5) lwidth(thin)) 	///
	blabel(bar)										///
		
	***************************************************
	* STACKED BAR CHARTS 
	*****************************************************
		
	* Stacked bar charts are similar to pie charts in that they present each category 
	* as a proportion of a total. 
	* The obvious difference is that the shape is rectangular rather than circular.
		
	graph bar, over(healthstatus) asyvars stack
	* Equivalent to 
	tab healthstatus

	* asyvars - specifies that the first over() group be treated as yvars
	
	* This is similar to adding each category of healthstatus which were stored 
	
	* individually as variables
	
	* graph bar very_good good fair poor very_poor, stack
		
	#delimit ;
	graph bar, over(healthstatus) asyvars stack
		bar(1, fcolor(gs13) lcolor(black)) 
		bar(2, fcolor(gs10) lcolor(black)) 
		bar(3, fcolor(gs7)  lcolor(black)) 
		bar(4, fcolor(gs4)  lcolor(black)) 
		bar(5, fcolor(gs1)  lcolor(black))
		scheme(plotplain)
	;
	#delimit cr
		
	*************************** Stacked bar charts using over() ****************

	* Stacked bar charts are useful when one categorical variable has many levels. 
		
	* You can use graded color intensity or gray scales to emphasize the ordinal 
	
	* nature of variables.

	* Over here we are using the horizontal stacked bar compared to the vertical
	
	* we saw earlier
		
	#delimit ;
	graph hbar, over(healthstatus) over(race) 
		asyvars 
		percentages 
		stack 
		bar(1, fcolor(gs13*1.2) lcolor(black)) 
		bar(2, fcolor(gs10*1.2) lcolor(black)) 
		bar(3, fcolor(gs7*1.2)  lcolor(black)) 
		bar(4, fcolor(gs4*1.2)  lcolor(black)) 
		bar(5, fcolor(gs1*1.2)  lcolor(black))
		scheme(plotplain)
	;
	#delimit cr
		
		
		
	***** More Useful Graphs
	graph bar, over(rural) over(region) asyvars blabel(bar) scheme(plotplain)
	tabulate rural region, nofreq cell
		
	graph bar, over(rural) over(region) asyvars blabel(bar) percentages scheme(plottig)
	tabulate rural region, nofreq column
		
	graph bar, over(region) over(rural) asyvars blabel(bar) percentages	
	tabulate rural region, nofreq row
		
		
	* asyvars means treating the first over() variable as separate Y variables
	
	* in this case that is region (Hence all regions will have different colors)
		
	* blabel() attaches label to each bar
		
		
		
	********** Histograms using by() *************
		
	histogram cholesterol, by(heartattack)
		
	* By default, the by() option created side by side plots of the categories
	* within the specified variable
		
	* Soemtimes it is easier to look at the visuals in a stacked manner for which
	
	* we specify that we want to see the graph in 2 rows or more (depending)
		
	histogram cholesterol, by(heartattack, rows(2))
		
			
	**** Additional Notes ****
		
	* Suppose you had a .gph file saved but did not know the command used to make
	
	* that particular graph, we can ask stata to show us how it was done:
		
	gs_graphinfo "Graph"
	display r(command)
		
		
	**** italics, bold, superscripts, and subscripts ******

	sysuse auto, clear
		   
	twoway (scatter price mpg),         /// 
		 title(This title includes {bf:bold}  {it:italics}  {sub:subscript} and {sup:superscript} fonts) ///
		 graphregion(color(white))

		  
	***** Special Characters ********
		   
	twoway  (lfitci price mpg, lwidth(thick)),      ///     
		   title("y{subscript:i} = {bf:X}{&beta} + {&epsilon}{sub:i}", size(huge)) ///
		   graphregion(color(white))
			