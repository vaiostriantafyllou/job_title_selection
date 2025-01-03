clear all
set more off

import excel "title_counts_across.xlsx", firstrow clear 
rename Count Count_across_vac

save "title_counts_across.dta", replace

import excel "title_counts.xlsx", firstrow clear 

merge 1:1 Code_prefix Alt using "title_counts_across.dta"
drop _merge
keep if Count_across>0
gen share = Count/Count_across

replace Alternate = subinstr(Alternate, "\", "", .)

gsort Code_prefix - Count

*hist Count, width(10)

keep if share>0.5

gen mcount = - Count

bysort Code(mcount): gen rank = _n

keep if rank <= 20

keep Code Alternate Count Count_across share

export excel "output_titles_final.xlsx", replace
