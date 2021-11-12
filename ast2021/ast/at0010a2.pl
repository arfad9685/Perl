sub at0010a2 {

genfuncast::view_header($in{ss}, $s3s[2], 'Tambah Inventori PC');
#genfuncast::validasi_akses($s3s[11], $in{ss});

@kondisi = ('B','L');
@kondisitext = ('Baru','Layak');

@flag = ('Y');
@flagtext = ('Yes');

if ($in{action} eq 'add')
{
  for ($i=0; $i<$in{baris}; $i++)
  {
   if ($in{"jen$i"})
   {
     $in{"kode$i"}=~ s/\'/\ /g;
     $in{"kode$i"}=~ s/\"/\ /g;
     $in{"jen$i"}=~ s/\'/\ /g;
     $in{"jen$i"}=~ s/\"/\ /g;
   
     $subq = "";
     if($in{"kodeasset$i"}){ $subq.="or kodeasset='".$in{"kodeasset$i"}."'"; }
     if($in{"kodelama$i"}){ $subq.="or kodelama='".$in{"kodelama$i"}."'"; }
     if($in{"noseri$i"}){ $subq.="or noseri='".$in{"noseri$i"}."'"; }
     $subq = substr $subq,3;
     #print qq~select kode, currcabang from inventori where $subq ~;
     $query = $dba1->prepare("select kode, currcabang from inventori where $subq ");
     $query->execute();
     @row = $query->fetchrow_array();

     if($row[0])
     { $warning = "<div class='warning_not_ok'>Inventori dengan Kode Asset '".$in{"kodeasset$i"}."' / Kode Lama '".$in{"kodelama$i"}."' / No Seri '".$in{"noseri$i"}."'
       sudah ada yaitu $row[0] di $row[1] </div><br/> ";
     }
     elsif($in{"flagasset$i"} eq 'Y' and !$in{"kodeasset$i"})
     { $warning = "<div class='warning_not_ok'>Bila Flag Asset di-Cek, Kode Asset harus diisi </div><br/> ";
     }
     elsif (!$in{"jen$i"} or !$in{"merek$i"} or !$in{"noseri$i"} or !$in{"kondisi$i"} or !$in{"dtbeli$i"}  or !$in{"currcabang$i"})
     { $warning = "<div class='warning_not_ok'>Isilah field-field di bawah dengan benar </div><br/> ";
     }
   }
  }
  
  if($warning eq "")
  {
   for ($i=0; $i<$in{baris}; $i++)
   {
     if ($in{"jen$i"})
     {
       if (!$in{"flagasset$i"}) {$flag="N";}
       else {$flag="Y";}

       @cab=split(/\-/,$in{"currcabang$i"});
       $kodecab = $cab[0];
   
       $idlama="0";

       $query = $dba1->prepare("select counter from jenisinv where jenis='".$in{"jen$i"}."' ");
       $query->execute();
       @row = $query->fetchrow_array();
       $ctr = $row[0]+1;
        if($ctr>1000){  }
        elsif($ctr>=100){ $ctr="0".$ctr; }
        elsif($ctr>=10){ $ctr="00".$ctr; }
        else { $ctr="000".$ctr; }
        if($in{"dtbeli$i"})
        { $in{"dtbeli$i"} = genfuncast::formatMDY($in{"dtbeli$i"});
          ($m,$d,$y) = genfuncast::getMdy($in{"dtbeli$i"});
          $year = substr $y,-2;
          if($m<10){ $m="0$m"; }
        }
        else { $year='19'; $m='01'; }
        $kode = $in{"jen$i"}.$year.$m.$ctr;

       if($i==0){ $groupkode=$kode; }
       
       $subkolom="", $subvalue="";
       if ($in{"harga$i"}) { $subkolom.=",HARGA";  $subvalue.=",'".$in{"harga$i"}."'"; }
       if ($in{"dtbeli$i"}) { $subkolom.=",DTBELI";  $subvalue.=",'".$in{"dtbeli$i"}."'"; }
       if ($in{"tipe$i"}) { $subkolom.=",TIPE";  $subvalue.=",'".$in{"tipe$i"}."'"; }
       if ($in{"ukuran$i"}) { $subkolom.=",UKURAN";  $subvalue.=",'".$in{"ukuran$i"}."'"; }
       if ($in{"kodeasset$i"}) { $subkolom.=",kodeasset";  $subvalue.=",'".$in{"kodeasset$i"}."'"; }

#       if($s3s[0] eq 'XTIN')
#       { print "INSERT INTO INVENTORI (KODE,JENIS,MEREK,KONDISI,KETERANGAN,FLAGASSET,NOSERI,IP,CURRCABANG,CURRIDLAMA,WARNA,KODELAMA,OS,COMPUTERNAME,
#        OPRCREATE, groupkode $subkolom) VALUES
#            ('$kode', '".$in{"jen$i"}."', '".$in{"merek$i"}."', '".$in{"kondisi$i"}."','".$in{"keterangan$i"}."', '$flag',
#            '".$in{"noseri$i"}."', '".$in{"ip$i"}."','$kodecab', '$idlama', '".$in{"warna$i"}."','".$in{"kodelama$i"}."','".$in{"os$i"}."',
#            '".$in{"computername$i"}."','$s3s[0]', '$groupkode' $subvalue );<BR/> ";
#       }

       $q1 = $dba1->do("
        INSERT INTO INVENTORI (KODE,JENIS,MEREK,KONDISI,KETERANGAN,FLAGASSET,NOSERI,IP,CURRCABANG,CURRIDLAMA,WARNA,KODELAMA,OS,COMPUTERNAME,
        OPRCREATE, groupkode $subkolom) VALUES
            ('$kode', '".$in{"jen$i"}."', '".$in{"merek$i"}."', '".$in{"kondisi$i"}."','".$in{"keterangan$i"}."', '$flag',
            '".$in{"noseri$i"}."', '".$in{"ip$i"}."','$kodecab', '$idlama', '".$in{"warna$i"}."','".$in{"kodelama$i"}."','".$in{"os$i"}."',
            '".$in{"computername$i"}."','$s3s[0]', '$groupkode' $subvalue );");

       if($q1!=0)
       { $q2 = $dba1->do("update jenisinv set counter=counter+1 where jenis='".$in{"jen$i"}."';");

         $jenisinv = $in{"jen$i"};
         $in{"dtbeli$i"} = genfuncast::formatMDY($in{"dtbeli$i"});
         ($m,$d,$y)=genfuncast::getMdy($in{"dtbeli$i"});
         $m=substr "0$m",-2;
         $periode = $y."-".$m;

         if ($q2!=0)
         { $q3 = $dba1->do("update stok set masuk = masuk+1, oprupdate='$s3s[0]' where jenisinv='$jenisinv' ;");
           if($q3!=0)
           { $warning .= "<div class='warning_ok'>Sukses Add Inventori dengan kode : '$kode'</div><br/> ";
           }
           else { $warning .= "<div class='warning_not_ok'>Gagal Add Inventori (3=$q3)</div><br/> "; }
         }
         else { $warning .= "<div class='warning_not_ok'>Gagal Add Inventori (2=$q2)</div><br/> "; }
       }
       else { $warning .= "<div class='warning_not_ok'>Gagal Add Inventori (1=$q1)</div><br/> "; }
     }
   }
  }
}

print qq~
<script type="text/javascript">
function toSubmit()
{  var result = confirm("Yakin Simpan Inventori?");
        if (result==true) {
         with(document.add)
          { action.value='add';
            submit();
          }
         }
}
</script>
~;

print qq~
<div class="container">
     <table width=1000 border="0" cellspacing="0" cellpadding="0">
     <tr>
     <td align=left width=200>
     <form method=post action="/cgi-bin/sisasset.cgi" >
      <input type="submit" name="back" value="BACK" class="huruf1"/>
      <input name="pages" type="hidden" value=at0010>
      <input name="ss" type="hidden" value="$in{ss}"> </form>
     </td>
     <td align=center> <h2 class="hurufcol">Tambah Inventori PC</h2> </td>
     <td align=right width=200>
     &nbsp;
     </td>
     </tr>
     </table>
~;


print qq~
$warning
<script type='text/javascript' src='/jquery.min.js'></script>
<script type='text/javascript' src="/jquery.chained.js"></script>

<style type="text/css">\@import url("/jscalendar/calendar-blue.css");</style>
<script type="text/javascript" src="/jscalendar/calendar.js"></script>
<script type="text/javascript" src="/jscalendar/lang/calendar-en.js"></script>
<script type="text/javascript" src="/jscalendar/calendar-setup.js"></script>

<form action="/cgi-bin/sisasset.cgi" method="post" name='add'>
  <input type=hidden name=ss value="$in{ss}">
  <input type=hidden name=pages value='at0010a2'>
  <input name="pageid" type="hidden" value='$tmp_tgl[3]'>
  <input name="action" type="hidden" value=''>

<table width='1100px' border='0' cellspacing='2' cellpadding='2'>
  <tr bgcolor=$colcolor height=20>
    <td class="hurufcol"  valign=top><b>Jenis Inventori</b> </td>
    <td class="hurufcol"  valign=top>Flag Asset</td>
    <td class="hurufcol"  valign=top><b>Merek</b> </td>
    <td class="hurufcol"  valign=top>Model/Tipe </td>
    <td class="hurufcol"  valign=top>Ukuran </td>
    <td class="hurufcol"  valign=top>Warna </td>
    <td class="hurufcol"  valign=top><b>No. Seri</b> </td>
    <td class="hurufcol"  valign=top>Kode Lama </td>
    <td class="hurufcol"  valign=top><b>Kondisi</b> </td>
    <td class="hurufcol"  valign=top><b>Tgl Beli</b> </td>
    <td class="hurufcol"  valign=top>Harga </td>
    <td class="hurufcol"  valign=top><b>Cabang</b> </td>
    <td class="hurufcol"  valign=top>Keterangan </td>
    <td class="hurufcol"  valign=top>Comp Name </td>
    <td class="hurufcol"  valign=top>IP </td>
    <td class="hurufcol"  valign=top>OS </td>
  </tr>
~;
$query = $dba1->prepare("SELECT jenis,namajenis FROM JENISINV ORDER BY namajenis");
$query->execute(); $i=0;
while (@rec = $query->fetchrow_array())
{  $jnsinv[$i]=$rec[0];
   $jnsinvtext[$i]=$rec[1];
   $i++;
}

$query = $dba1->prepare("SELECT merek,namamerek FROM merek ORDER BY namamerek ");
$query->execute(); $i=0;
while (@rec = $query->fetchrow_array())
{  $merk[$i]=$rec[0];
   $merktext[$i]=$rec[1];
   $i++;
}

$query = $dba1->prepare("SELECT tipe,namatipe,jenis FROM TIPEINV ORDER BY tipe");
$query->execute(); $i=0;
while (@rec2 = $query->fetchrow_array())
{  $tipe[$i]=$rec2[0];
   $tipejns[$i]=$rec2[2];
   $i++;
}

$query = $dba1->prepare("SELECT ukuran,namaukuran FROM  ukuraninv ORDER BY namaukuran ");
$query->execute(); $i=0;
while (@rec = $query->fetchrow_array())
{  $ukuran[$i]=$rec[0];
   $ukurantext[$i]=$rec[1];
   $i++;
}

$query = $dba1->prepare("SELECT warna,namawarna FROM warna ORDER BY namawarna ");
$query->execute(); $i=0;
while (@rec = $query->fetchrow_array())
{  $warna[$i]=$rec[0];
   $warnatext[$i]=$rec[1];
   $i++;
}

$query = $dba1->prepare("select kodecabang,namacabang, kodebu from getstruk where (kodecabang like 'MW%') order by kodecabang");
$query->execute(); $i=0;
while (@rec = $query->fetchrow_array())
{  $pilcab[$i]=$rec[0];
   $pilcabtxt[$i]=$rec[0]." - ".$rec[1];
   $i++;
}

for ($i=0; $i<10; $i++)
{ print qq~
  <tr bgcolor=$colcolor2 height=20 class="hurufcol">
    <td valign=top>
        ~;
        if(!$in{"jen$i"})
        { if($i==0) { $in{"jen$i"}="PCDSKT"; }
          if($i==1) { $in{"jen$i"}="PCDMBO"; }
          if($i==2) { $in{"jen$i"}="PCDPRC"; }
          if($i==3) { $in{"jen$i"}="PCDRAM"; }
          if($i==4) { $in{"jen$i"}="PCDHDD"; }
        }

        if($i==0)
        { print qq~<input type=hidden name='jen$i' value='PCDSKT'/>COMPUTER DESKTOP                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ~;
        }
        else
        { print qq~<select name="jen$i" class="huruf1" id="jen$i">
          <option value=''>-</option>~;
          for ($j=0; $j<@jnsinv; $j++)
          { $selected="";
            if($in{"jen$i"} eq $jnsinv[$j]) { $selected="selected"; }
            print qq~<option value='$jnsinv[$j]' $selected>$jnsinvtext[$j]</option>~;
          }
          print qq~</select>~;
        }
        print qq~
    </td>
    <td valign=top>
    ~;
    $checked=""; $vis="hidden";
    if ($in{"flagasset$i"} eq  'Y') {$checked="checked"; $vis="visible"; }
    print "<input type=checkbox name=flagasset$i value='Y' class=huruf1 $checked
    onchange=\"if(this.checked){ document.getElementById('kda$i').style.visibility='visible';}
    else {document.getElementById('kda$i').style.visibility='hidden';} \"> Yes &nbsp; &nbsp; &nbsp;
    <div name='kda$i' id='kda$i' style='visibility:$vis'>   Kode Asset:
    <input type=text name=kodeasset$i id=kodeasset$i value='".$in{"kodeasset$i"}."' class= keyboardInput maxlength=10 size=10 >
    </div> ";
    print qq~
    </td>
    <td valign=top>
        <select name="merek$i" class="huruf1" id="merek$i">
        <option value=''>-</option>~;
        for ($j=0; $j<@merk; $j++)
        { $selected="";
          if($in{"merek$i"} eq $merk[$j]) { $selected="selected"; }
          print qq~<option value='$merk[$j]' $selected>$merktext[$j]</option>~;
        }
        print qq~
        </select>
    </td>
    <td valign=top>
       <select name="tipe$i" class="huruf1" id="tipe$i">
       <option value=''>-</option>~;
        for ($j=0; $j<@tipe; $j++)
        { $selected="";
          if($in{"tipe$i"} eq $tipe[$j]) { $selected="selected"; }
          print qq~<option value='$tipe[$j]' $selected  class='$tipejns[$j]'>$tipe[$j]</option>~;
        }
     print qq~
    </select>
    <script language="javascript" >
     \$("#tipe$i").chained("#jen$i");
    </script>
    </td>
    <td valign=top>
        <select name="ukuran$i" class="huruf1" id="ukuran$i">
        <option value=''>-</option>~;
        for ($j=0; $j<@ukuran; $j++)
        { $selected="";
          if($in{"ukuran$i"} eq $ukuran[$j]) { $selected="selected"; }
          print qq~<option value='$ukuran[$j]' $selected>$ukuran[$j]</option>~;
        }
        print qq~
        </select>
    </td>
    <td valign=top>
        <select name="warna$i" class="huruf1" id="warna$i">
        <option value=''>-</option>~;
        for ($j=0; $j<@warna; $j++)
        { $selected="";
          if($in{"warna$i"} eq $warna[$j]) { $selected="selected"; }
          print qq~<option value='$warna[$j]' $selected>$warna[$j]</option>~;
        }
        print qq~
        </select>
    </td>
    <td valign=top>
       ~; print "<input type=text name=noseri$i value='".$in{"noseri$i"}."'  maxlength=30 size=15>";
       print qq~
    </td>
    <td valign=top>
       ~; print "<input type=text name=kodelama$i value='".$in{"kodelama$i"}."'  maxlength=20 size=8>";
       print qq~
    </td>
    <td valign=top>
        <select name="kondisi$i" class="huruf1" id="kondisi$i">
        <option value=''>-</option>~;
        if(!$in{"kondisi$i"}){ $in{"kondisi$i"}="L";}
        for ($j=0; $j<@kondisi; $j++)
        { $selected="";
          if($in{"kondisi$i"} eq $kondisi[$j]) { $selected="selected"; }
          print qq~<option value='$kondisi[$j]' $selected>$kondisi[$j]</option>~;
        }
        print qq~
        </select>
    </td>
    <td valign=top>~;
    print "
      <input name=\"dtbeli$i\" type=\"text\" id=\"dtbeli$i\" size=\"10\" maxlength=\"12\" class=\"huruf1\" value=\"".$in{"dtbeli$i"}."\" />
        <img src=\"/jscalendar/img.gif\" id=\"trigger1$i\" style=\"cursor: pointer; border: 1px solid blue;\"
                title=\"Date selector\" onMouseOver=\"this.style.background='blue';\" onMouseOut=\"this.style.background=''\" />
        <script type=\"text/javascript\">
        Calendar.setup(
        {
                inputField  : \"dtbeli$i\",         // ID of the input field
                ifFormat    : \"%m/%d/%Y\",    // the date format
                button      : \"trigger1$i\"       // ID of the button
	       //daFormat  :  \"%Y/%m/%d\"
        }
        );


        </script>";
        print qq~
    </td>
    <td valign=top>
       ~; print "<input type=text name=harga$i value='".$in{"harga$i"}."'  maxlength=15 size=8>";
       print qq~
    </td>
    <td valign=top>
       <select name=currcabang$i id=currcabang$i>
      <option value=''>-</option>~;
        for ($j=0; $j<@pilcab; $j++)
        { $selected="";
          if($in{"currcabang$i"} eq $pilcab[$j]) { $selected="selected";}
          print qq~<option value='$pilcab[$j]' $selected>$pilcab[$j]</option>~;
        }
        print qq~
      </select>
    </td>
    <td valign=top>
       ~; print "<input type=text name=keterangan$i value='".$in{"keterangan$i"}."'  maxlength=30 size=15>";
       print qq~
    </td>
    <td valign=top>
       ~; print "<input type=text name=computername$i value='".$in{"computername$i"}."'  maxlength=20 size=8>";
       print qq~
    </td>
    <td valign=top>
       ~; print "<input type=text name=ip$i value='".$in{"ip$i"}."'  maxlength=15  size=8>";
       print qq~
    </td>
    <td valign=top>
       ~; print "<input type=text name=os$i value='".$in{"os$i"}."'  maxlength=20  size=8>";
       print qq~
    </td>
  </tr>
  ~;

}

$baris = $i-1;
print qq~
</table>
 <input type=hidden value='$baris' name="baris" >
 <input type=button value='Simpan' name="simpan" class="huruf1" onClick="toSubmit();">
</form>
    <hr width="100" />
</center>~;
}


1

