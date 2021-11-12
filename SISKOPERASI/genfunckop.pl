#!/usr/bin/perl

package genfunckop;

sub view_header_kop
{     ($ss, $nama, $judul, $s3s17) = @_;
print qq~

    <table width="40%" border="0" cellspacing="0" cellpadding="1" align="right" style="background-color:#ffffff">
      <tr height=24 bgcolor=$menucolor>
        <td align=left><strong><span class="menu2">&nbsp; $judul &nbsp;</span></strong></td>
        <td align=right><span class="menu2">&nbsp;User : $nama &nbsp;~;

  print qq~
        <a href="/cgi-bin/siskop.cgi?pages=kop002&fr=pyl&ss=$ss"><img src="/images/toolbar_home_kop.png" width="24" height="24" align="absmiddle" border="0"/></a>
      ~;
  if($s3s17 eq 'Y')
  {
    print qq~
        <a href="/cgi-bin/sispayroll.cgi?pages=py002&ss=$ss"><img src="/images/toolbar_home_pyl.png" width="24" height="24" align="absmiddle" border="0"/></a>~;
  }
  print qq~
        </td>
      </tr>
    </table>
    <hr width="100%" />
    <br>
<center>
<p>    ~;
}

sub validasi_akses_kop
{     ($hak, $ss, $ceks) = @_;
        if ($hak eq 'N')
        { print qq~<meta http-equiv="refresh" content="0;url=siskop.cgi?pages=kop002&ss=$ss">~;
        }
        $ceks = 'N' unless defined $ceks;
        if ($ceks eq 'S' and $hak ne 'S')
        { print qq~<meta http-equiv="refresh" content="0;url=siskop.cgi?pages=kop002&ss=$ss">~; }
}

sub getPeriodeKop
{  ($dt) = @_;
   ($m,$d,$y) = genfuncpyl::getMdy($dt);
   if ($y<100) { $y="20$y"; }
   if ($m<10) { $m="0$m"; }
   $psid = $y."-".$m;
   return $psid;
}
#sub getPeriodeKop
#{  ($dt) = @_;
#   ($m,$d,$y) = getMdy($dt);
#   if ($y<100) { $y="20$y"; }
#   if ($m<10) { $m="0$m"; }

#   if ($d<=20) { $psid = $y."-".$m; }
#   elsif ($m==12)      # $d>20 (tgl 21 ke atas)
#   {  $y++; $m="01";
#      $psid = $y."-".$m;
#   }
#   else
#   {  $m++; if ($m<10) { $m="0$m"; }
#      $psid = $y."-".$m;
#   }
#   return $psid;
#}

sub getMdy
{  ($dt) = @_;
   $garing1 = index($dt, '/');
   $garing2 = index($dt, '/',$garing1+1);
   $m = substr $dt,0,$garing1;
   $m = $m - 0;
   $a=$garing1+1;
   $b=$garing2-1;
   $d = substr $dt,$a,$b;
   $d = $d - 0;
   $y = substr $dt,$garing2+1,4;
   $y = $y - 0;
   if ($y<10) { $y="200$y"; }
   elsif ($y<50) { $y="20$y"; }
   elsif ($y<100) { $y="19$y"; }
   return ($m, $d, $y);
}

1;
