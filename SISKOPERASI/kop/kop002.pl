sub kop002 {

#&prtstatipxx;
#print qq~depid=$s3s[13]~;
use Date::Calc qw(Add_Delta_Days);
use Date::Calc qw(Day_of_Week);

genfunckop::view_header_kop($in{ss}, $s3s[2], 'Home', $s3s[17]);

($month,$day,$year,$weekday) = &jdate(&today());
$month = substr "0".$month, -2;
$day = substr "0".$day, -2;
$today = $month."/".$day."/".$year;
$todaydt = $day."/".$month."/".$year;
$ymd = "$year$month$day";
$month=$month-0;

($m,$d,$y,$wd) = &jdate(&tambahhari(-2));
$m = substr "0".$m, -2;
$d = substr "0".$d, -2;
$duaharilalu = $d.'/'.$m.'/'.$y;

$psid = genfuncpyl::getPeriodeSC($today);
($dt1, $dt2) = genfuncpyl::getTglPeriode($month, $day, $year);

  print qq~
  <table width='500px' border='0' cellspacing='1' cellpadding='3'>
  <tr bgcolor="$dark">
   <td align='center' class="hurufcol"> <b>ALERT KOPERASI </b> </td>
  </tr>
  ~;

    $q = $dbk->prepare("select distinct i.idlama, nik, nlengkap, dtgerak, gerakid from iuran i, getkryout o, getkry k
where i.idlama = o.idlama and o.idlama=k.idlama and pencairanid is null ");
    $q->execute();   $i=1;
    while (@row = $q->fetchrow_array())
    { if($i==1)
      { print qq~<tr bgcolor="pink" class="hurufcol">
        <td> Pencairan Simpanan Karyawan Resign : <br/> ~;
      }
      $dtrsg=genfuncpyl::mdytodmy($row[3]);
      print qq~<a href="/cgi-bin/siskop.cgi?pages=kop022c&nikgo=$row[1]-$row[2]&ss=$in{ss}&dtcair=$row[3]&cair=all" class=hurufcol>$row[1]-$row[2] : $row[4] $dtrsg</a><br/> ~;
      $n++;
      $i++;
    }
    
    if($i>1)
    { print qq~</td>
      </tr> ~;
    }
      
  if ($n==0)
  { print qq~<tr bgcolor="$colcolor" class="hurufcol"><td align=center> - No Alert -</td></tr>  ~; }
  print qq~
  </table> ~;

  print "<hr width=100/> ";
}

;
1

