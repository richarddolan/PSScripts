$site = "https://jhcloud.sharepoint.com/sites/pa"
$list = "HospitalContracts"
$csv = import-csv PAHospitalContractsToMoveFinal.csv

#connect-pnponline -url $site -interactive
foreach($item in $csv)
	{
		Set-PnPListItem -List "contracts" -Identity $item.NewID -Values @{"Facility" = $item.Facility; "City" =$item.FacilityLocation; "Contract_x0020_Accountant" =$item.ContractAccountant; "RVP" =$item.RVP;}	
	}