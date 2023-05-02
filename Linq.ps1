#https://www.red-gate.com/simple-talk/development/dotnet-development/high-performance-powershell-linq/#post-71022-_Toc482783697

$Left = @()
$Right = @()
$ProductionStatusArray = @('In Production','Retired')
$PowerStatusArray = @('Online','Offline')
1..15 | Foreach-Object {
    $Prop = @{
        Name = "Server$_"
        PowerStatus = $PowerStatusArray[(Get-Random -Minimum 0 -Maximum 2)]
    }
    $Left += New-Object -Type PSObject -Property $Prop
}
1..10 | Foreach-Object {
    $Prop = @{
        Name = "Server$_"
        ProductionStatus = $ProductionStatusArray[(Get-Random -Minimum 0 -Maximum 2)]
    }
    $Right += New-Object -Type PSObject -Property $Prop
}
 
#In this instance both joins will be using the same property name so only one function is needed
[System.Func[System.Object, string]]$JoinFunction = {
    param ($x) 
    $x.Name 
}
 
#This is the delegate needed in GroupJoin() method invocations
[System.Func[System.Object, [Collections.Generic.IEnumerable[System.Object]], System.Object]]$query = {
    param(
        $LeftJoin,
        $RightJoinEnum
    )
    $RightJoin = [System.Linq.Enumerable]::SingleOrDefault($RightJoinEnum)
 
    New-Object -TypeName PSObject -Property @{
        Name = $LeftJoin.Name; 
        PowerStatus = $LeftJoin.PowerStatus; 
        ProductionStatus = $RightJoin.ProductionStatus
    }
}
 
#And lastly we call GroupJoin() and enumerate with ToArray()
[System.Linq.Enumerable]::ToArray(
    [System.Linq.Enumerable]::GroupJoin($Left, $Right, $JoinFunction, $JoinFunction, $query)
)