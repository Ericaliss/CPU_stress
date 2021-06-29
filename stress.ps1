#Stress function to apply on the Logical Processors#
function stress{
    param([int]$Number )
    ForEach ($core in 1..($Number)){ 
 
        start-job -ScriptBlock{
 
            $result = 1;
            foreach ($loopnumber in 1..2147483647){
                $result=1;
        
                foreach ($loopnumber1 in 1..2147483647){
                $result=1;
            
                    foreach($number in 1..2147483647){
                        $result = $result * $number
                    }
                }
 
                $result
            }
        }
    }
}

function get_logicalprocessors{
    
    $version = $PSVersionTable.psversion
    #TODO : Add check if Windows or Linux : only work on Windows#
    if($version -ge '6.0'){
        if($IsWindows){
            $NumberOfLogicalProcessors = Get-WmiObject win32_processor | Select-Object -ExpandProperty NumberOfLogicalProcessors
        }
        else{
	    #TODO : test#
            $NumberOfLogicalProcessors = (Get-CimInstance -Class 'CIM_Processor').NumberOfLogicalProcessors
        }
    }
    else{
        if($env:OS -eq "Windows_NT"){
            $NumberOfLogicalProcessors = Get-WmiObject win32_processor | Select-Object -ExpandProperty NumberOfLogicalProcessors
        }
        else{
	    #TODO : test#
            $NumberOfLogicalProcessors = (Get-CimInstance -Class 'CIM_Processor').NumberOfLogicalProcessors
        }
    }
    return $NumberOfLogicalProcessors;
}

#Fix value of stress#
function Fixe{
    $Number = Read-Host "Number of Logical Processors to use ";

    if($Number -ge $NumberOfLogicalProcessors){
        $Number = [int]$NumberOfLogicalProcessors;
    }
    
    Get-Date -Format "dddd MM/dd/yyyy HH:mm:ss";
    $string = "Number of Logical Processors used : {0}" -f $Number;
    Write-Output $string;

    stress -Number $Number
 
    Read-Host "Press any key to exit..."
    Stop-Job *
}

# Alternate between two values of stress#
function Alternate{
    $min = Read-Host "First Value ";

    $max = Read-Host "Second Value ";
    $max = [int]$max;
    $min = [int]$min;

    if($min -le 0){
        $min = [int]0;
    }
    if($max -le 0){
        $max = [int]0;
    }
    if($min -ge $NumberOfLogicalProcessors){
        $min = [int]$NumberOfLogicalProcessors;
    }
    if($max -ge $NumberOfLogicalProcessors){
        $max = [int]$NumberOfLogicalProcessors;
    }

    #Delay between changes of RandomNumber (in seconds)
    $delay = Read-Host "Change time (seconds) ";

    #state
    $state = $true;

    while($true){
    
    #Number between $min $max
        if($state){
            $Number = $min;
            $state = -Not $state
        }
        else{
            $Number = $max;
            $state = -Not $state;
        }
        #Print Date, Hour and number of logical Processors
        write-host "`n";
        Get-Date -Format "dddd MM/dd/yyyy HH:mm:ss";
        $string = "Number of Logical Processors : {0}" -f $Number;
        Write-Output $string;
        write-host "`n";
        
       #Stress RandomNumber of LogicalProcessors
       if($Number -eq 0){
       }
       else{
            stress -Number $Number
        }
    #Sleep $delay of time until changes of RandomNumber
        Start-Sleep -s $delay;
    #Stop the background tasks
        Stop-Job *;
    }
}
#Random value of stress#
function Random{
    $min = Read-Host "Minimum Value ";

    $max = Read-Host "Maximum Value ";
    $max = [int]$max;
    $min = [int]$min;
    if($min -le 0){
        $min = [int]0;
    }
    if($max -le $min){
        $max = $min+[int]1;
    }
    if($max -ge $NumberOfLogicalProcessors){
        $max = [int]$NumberOfLogicalProcessors;
    }
    if($min -ge $max){
        $min = $max-[int]1;
    }
    

    

    #Delay between changes of RandomNumber (in seconds)
    $delay = Read-Host "Change time (seconds) ";

    while($true){
        #RandomNumber between $min $max-1
        $RandomNumber = (Get-Random -Maximum ($max+[int]1) -Minimum $min);
        #Print Date, Hour and number of logical Processors
        write-host "`n";
        Get-Date -Format "dddd MM/dd/yyyy HH:mm:ss";
        $string = "Number of Logical Processors : {0}" -f $RandomNumber;
        Write-Output $string;
        write-host "`n";
        if($RandomNumber -eq 0){

        }
        else {
        #Stress RandomNumber of LogicalProcessors
        stress -Number $RandomNumber
    }
    #Sleep $delay of time until changes of RandomNumber
    Start-Sleep -s $delay;
    #Stop the background tasks
    Stop-Job *;
    }    
}
#Enter the value for the operation mode#
function Enter_value{
    $Mode = Read-Host "Mode ";
    switch($Mode){
        1{Fixe}
        2{Alternate}
        3{Random}
        default{
            Write-Host "Enter a valid value !";
            Enter_value;
        }
    }

}




#MAIN#
$NumberOfLogicalProcessors = get_logicalprocessors;
$sum = 0;
foreach ($element in $NumberOfLogicalProcessors) {
  $sum = $sum + $element
}

$NumberOfLogicalProcessors = $sum
$string = "Number of Logical Processors : {0}" -f $NumberOfLogicalProcessors;
Write-Output $string;
$string = "Choose Mode";
Write-Output $string;
$string = "Mode 1 : Fixe";
Write-Output $string;
$string = "Mode 2 : Alternate";
Write-Output $string;
$string = "Mode 3 : Random";
Write-Output $string;
Enter_value

