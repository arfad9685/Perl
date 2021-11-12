#!/usr/bin/perl

#use_calendar
#use_numeral
#use_colorbox (framename,width,reload[Y/N])
#use_warning (var messages)
#use_notif (var messages)
#user_chkerror (var database)
#date_name (var mm/dd/yyy) return dd-month-yyyy
#input_calendar (id,value,counter)
#skkkdd (var raw number)

package style_module;

sub form_data {
               $menucolor="#FFFFFF";
               $header="#A64941";
               $divheader="#CCCCCC";
               $footer="#333333";
               $datacolor="#FFFFFF";      
               $colcolor="#545454";
               ($db,$cols_ref,$name_ref,$length_ref,$type_ref,$query_ref,$row_ref,$align_ref) = @_;
               $dbh=$db;
               @cols=@{$cols_ref};
               @name=@{$name_ref};
               @length=@{$length_ref};
               @type=@{$type_ref};
               @query=@{$query_ref};
               @row=@{$row_ref};
               @align=@{$align_ref};               
               for ( $i = 0 ; $i < scalar(@cols) ; $i++ ) {
                    if ( $type[$i] eq "textbox" ) {
                        print qq~
                            <tr>
                                <td align="left" bgcolor=$colcolor class="hurufcol">
                                    &nbsp;$cols[$i]
                                </td>
                                <td align="left" class="huruf1">:</td>
                                <td align="left" class="huruf1">
                                    <input type=text size="$length[$i]" name="$name[$i]" class="huruf1" maxlength="$length[$i]" value="$row[$i]" style="background-color: #FFFF99">
                                </td>
                            </tr>
                        ~;
                    }
                    elsif ( $type[$i] eq "query" ) {
                        print qq~
                            <tr>
                                <td align="left" bgcolor=$colcolor class="hurufcol">&nbsp;~
                                . $cols[$i] . qq~</td>
                                <td align="left" class="huruf1">:</td>
                                <td align="left" class="hurufcol">
                                <select name="~ . $name[$i] . qq~" class="huruf1" style="background-color: #FFFF99">~;
                                    $tbl_tree = $dbh->prepare(
                                        $query[$i]
                                    );
                                    $tbl_tree->execute();
                                    while ( @tree = $tbl_tree->fetchrow_array() ) {
                                        if($row[$i] eq $tree[0]){
                                            print qq~<option value="$tree[0]" selected>$tree[1]</option>~;    
                                        }else {
                                            print qq~<option value="$tree[0]">$tree[1]</option>~;    
                                        }
                                    }	
                                    print qq~
                                </select>
                                </td>
                            </tr>
                        ~;
                    }
                    elsif ( $type[$i] eq "select" ) {
                        print qq~
                            <tr>
                                <td align="left" bgcolor=$colcolor class="hurufcol">&nbsp;~
                                . $cols[$i] . qq~</td>
                                <td align="left" class="huruf1">:</td>
                                <td align="left" class="hurufcol">
                                <select name="~ . $name[$i] . qq~" class="huruf1" style="background-color: #FFFF99">~;
                                    @val = split("/", $query[$i]);
                                    for(my $c=0; $c<scalar(@val);$c++) {
                                        if($row[$i] eq $val[$c]) {
                                            print qq~<option value="$val[$c]" selected>$val[$c]</option>~;    
                                        }
                                        else{
                                            print qq~<option value="$val[$c]">$val[$c]</option>~;    
                                        }
                                    }	
                                    print qq~
                                </select>
                                </td>
                            </tr>
                        ~;
                    }
                    elsif ( $type[$i] eq "readonly" ) {
                        if ($align[$i]) {
                           $posisi="style='text-align: $align[$i]'"; 
                        } else {
                          $posisi="";
                        }
                        print qq~
                            <tr>
                                <td align="left" bgcolor=$colcolor class="hurufcol">
                                    &nbsp;$cols[$i]
                                </td>
                                <td align="left" class="huruf1">:</td>
                                <td align="left" class="huruf1">
                                    <input type=text size="$length[$i]" name="$name[$i]" class="huruf1" maxlength="$length[$i]" value="$row[$i]" readonly $posisi>
                                </td>
                            </tr>
                        ~;
                    }
                }
}


sub skkkdd
{
 ($aa1)=@_;
  $aa=int(abs($aa1));
  $dd=sprintf "%.2f", abs($aa1)-$aa;
  $cc="";
  $bb=length($aa);
  while($bb>3)
  {
   $cc=",".substr($aa,($bb-3),3).$cc;
   $aa=substr($aa,0,($bb-3));
   $bb=length($aa);
  }
 
  if ($dd >=0.01 ) {
   $dd=int($dd*100);
   if ($dd<10) {
    $dd='0'.$dd;
   }
   if (($aa1)<0) {
    $cc='-'.$aa.$cc.'.'.$dd;
   } else {
    $cc=$aa.$cc.'.'.$dd;
   }
  } else {
   if (($aa1)<0) {
    $cc='-'.$aa.$cc;
   } else {
    $cc=$aa.$cc;
   }
  }
  return $cc;
}

sub skkkff
{
 ($aa1)=@_;
  $aa=int(abs($aa1));
  $dd=sprintf "%.2f", abs($aa1)-$aa;
  $cc="";
  $bb=length($aa);
  while($bb>3)
  {
   $cc=",".substr($aa,($bb-3),3).$cc;
   $aa=substr($aa,0,($bb-3));
   $bb=length($aa);
  }
 
  if ($dd >=0.01 ) {
   $dd=int($dd*100);
   if ($dd<10) {
    $dd='0'.$dd;
   }
   if (($aa1)<0) {
    $cc='-'.$aa.$cc.'.'.$dd;
   } else {
    $cc=$aa.$cc.'.'.$dd;
   }
  } else {
   if (($aa1)<0) {
    $cc='-'.$aa.$cc.'.00';
   } else {
    $cc=$aa.$cc.'.00';
   }
  }
  return $cc;
}

sub use_calendar {
print qq~
<script src="/vendors/JSCal2-1.9/src/js/jscal2.js"></script>    
<script src="/vendors/JSCal2-1.9/src/js/lang/en.js"></script>
<link rel="stylesheet" type="text/css" href="/vendors/JSCal2-1.9/src/css/jscal2.css" />   
<link rel="stylesheet" type="text/css" href="/vendors/JSCal2-1.9/src/css/border-radius.css" />    
<link rel="stylesheet" type="text/css" href="/vendors/JSCal2-1.9/src/css/win2k/win2k.css" />
~;
}

sub input_calendar {
 ($name,$default,$no,$onchange,$min,$max,$day) = @_ ;
  print qq~
  <input size="9" name="$name" id="$name" value=$default readonly=readonly>&nbsp;<img src="/images/calendar.png" id="f_btn$no" style="cursor:pointer;vertical-align: middle;"><br />

    <script type="text/javascript">//<![CDATA[
      Calendar.setup({
        inputField : "$name",
        trigger    : "f_btn$no",
        onSelect   : function() { this.hide(); $onchange},
        align           : "Br",~;
        if ($min) {
           print qq~ min : $min,~;
        }
        if ($max) {
           print qq~ max : $max,~;
        }
        if ($day) {
           print qq~ disabled : function(date) {
              if (date.getDay() != $day) {
                 return true;
              } else {
                 return false;
              }            
           },
           ~;
        }
        print qq~        
        dateFormat : "%m/%d/%Y"
      });
    //]]></script>~;
}   

sub use_colorbox {
 ($frame,$width,$reload) = @_ ;  
 print qq~
 <link rel="stylesheet" href="/css/colorboxn.css" />
 <script type="text/javascript" src="/js/jquery.colorbox.js"></script>
 <script type="text/javascript">
 \$(document).ready(function(){
   \$(".$frame").colorbox({
      iframe:true,
      width: "$width px",
      height:"70%",
      overlayClose:false,
      escKey:false,            
      ~;
      if ($reload eq 'Y') {
        print qq~
        onClosed:function(){location.reload(true)},~;
      }
       print qq~
        onOpen: function(){
        \$('body').css({ overflow: 'hidden' });
      }
    });
    \$("#click").click(function(){
	 \$(".$frame").colorbox.close();
    });
 });
 </script>~;
}

sub use_warning { 
  print qq~
 <script type="text/javascript">  
  function warning(msg) {
  var r = confirm(msg+ " ?");
  if (r == true) {
    return true;
  } else {
    return false;
  }
 }
 </script>~;
} 

sub use_notif {
   ($notif) = @_ ;  
    print qq~
    <script language="JavaScript">
      window.onload= function () {alert("$notif")}
    </script>~;
}

sub use_chkerror {
    ($databases) = @_ ;
    $error_msg = $databases->errstr;   
    if ($error_msg) {
     print qq~
      <div class="alert">
        <span class="closebtn" onclick="this.parentElement.style.display='none';">&times;</span> 
        <strong>ERROR :</strong> $error_msg </div>~;  
    }
}

sub terbilang {
    $aa=$_[0];
    $sat=length($aa);
    for ($i=0; $i < $sat; $i++) {
       $pss[$i]=substr($aa,$i,1);
    }
    
    $pulribu='';$ribu='';$ratus='';$puljuta='';$tusribu='';
    $juta='';$tusjuta='';
    
    
   if ($sat > 7 )
   {
      if ($sat==9) {
       $n=9;
       $tmp=$pss[$sat-$n];
       $tmp2=$pss[$sat-$n+1];
       $tmp3=$pss[$sat-$n+2];              
       if (($tmp==1) && ($tmp2==0) &&  ($tmp3==0)) {
         $tusjuta=' Seratus Juta';
       }  
       if (($tmp==1) && ($tmp2==0) && ($tmp3==0)) {
          $tusjuta =nama($tmp).' Ratus Juta';
       }   
       if (($tmp==1) && (($tmp2 != 0) || ($tmp3 != 0))) {
        $tusjuta=' Seratus';
       } 
       if  (($tmp !=1) && (($tmp2 != 0) || ($tmp3 !=0))) {
        $tusjuta= nama($tmp).' Ratus';
       } 
       if ($tmp==0) { $tusjuta=''};
       if ($tusjuta) {
        $bilangan.=' '.$tusjuta;
       } 
       $n=8;
       if ($tmp2==1) 
       {
        if (($tmp2==1) && ($tmp3 !=1))
        {
          $bilangan.=' '.nama($tmp3).'belas Juta';
        }
        if  ($tmp3==0) {
         $bilangan.=' Sepuluh Juta';
        }
        if  ($tmp3 ==1) {
         $bilangan.=' Sebelas Juta';
        }
       } else 
       {
        $tmp=$pss[$sat-$n];
        $tmp2=$pss[$sat-$n+1];
        if (($tmp2 != 0) && ($tmp != 0)) {
         $puljuta=nama($tmp).' Puluh '.nama($tmp2).' Juta';
        } 
        if (($tmp2 != 0) && ($tmp==0)) {
         $puljuta=nama($tmp2).' Juta';
        } 
        if ($tmp2==0) {
         $puljuta=nama($tmp).'Puluh Juta';
        } 
        if (($tmp==0) && ($tmp2==0)) {
         $puljuta='';
        }
        if ($puljuta) {
          $bilangan.=' '.$puljuta;
        }  
       }
      } else
      {
       if ($pss[0]==1)
       {
        if (($pss[0]==1) && ($pss[1] != 0) &&  ($pss[1] != 1)) {
          $tmp=$pss[1];
          $bilangan.=' '.nama($tmp).'belas Juta';
        }
        if (($pss[0]==1) && ($pss[1]==0)) {    
         $bilangan=' Sepuluh Juta';
        }
        if (($pss[0]==1) && ($pss[1]==1)) {
          $bilangan.=' Sebelas Juta';
        };
       } else
       {
        $tmp=$pss[0];
        $tmp2=$pss[1];
        if ($pss[1] != 0) {
          $bilangan.=' '.nama($tmp).' Puluh '.nama($tmp2).' Juta';
        }
        if ($pss[1]==0) {
          $bilangan.=' '.nama($tmp).' Puluh Juta';
        }
       }
      }
    } 
    
    
    if ($sat==7) {
      $tmp=$pss[0];
      $juta=nama($tmp).' Juta';
      $bilangan.=$juta;
    }
    
    if ($sat > 5) {
       $n=6;
       $tmp=$pss[$sat-$n];
       $tmp2=$pss[$sat-$n+1];
       $tmp3=$pss[$sat-$n+2];       
       if  (($tmp==1) && ($tmp2==0) && ($tmp3==0))  {
          $tusribu='Seratus Ribu';
       }   
       if (($tmp != 1)  &&  ($tmp2 ==0) && ($tmp2==0)) {
         $tusribu =nama($tmp).' Ratus Ribu';
       }  
       if (($tmp==1) && (($tmp2 != 0 ) || ($tmp3 != 0))) {
         $tusribu='Seratus';
       }  
       if (($tmp !=1) &&  (($tmp2 != 0) ||  ($tmp3 != 0))) {
        $tusribu= nama($tmp).' Ratus';
       } 
       if  ($tmp ==0) { $tusribu='';}
       if ($tusribu) {
       $bilangan.=' '.$tusribu;}
    }
    
     if ($sat > 4) {       
      $n=5;
      if ($pss[$sat-$n]==1) {      
        if (($pss[$sat-$n]==1) && ($pss[$sat-$n+1] != 0) && ($pss[$sat-$n+1] != 1)) {
          $tmp=$pss[$sat-$n+1];
          $bilangan.=' '.nama($tmp).'belas Ribu';
        }
        if (($pss[$sat-$n]==1) && ($pss[$sat-$n+1]==0)) {
          $bilangan.=' '.'Sepuluh Ribu';
        }
        if (($pss[$sat-$n]==1) && ($pss[$sat-$n+1]==1)) {
          $bilangan.=$bilangan.' Sebelas Ribu';
        } 
      } else {
        $tmp=$pss[$sat-$n];
        $tmp2=$pss[$sat-$n+1];
        if (($pss[$sat-$n+1] !=0) && ($pss[$sat-$n] != 0)) {
         $pulribu=nama($tmp).' Puluh '.nama($tmp2).' Ribu';
        } 
        if (($pss[$sat-$n+1] !=0) && ($pss[$sat-$n] ==0)) {
          $pulribu=nama($tmp2).' Ribu';
        }  
        if ($pss[$sat-$n+1]==0) {
         $pulribu =nama($tmp).' Puluh Ribu';
        } 
        if (($pss[$sat-$n]==0) && ($pss[$sat-$n+1]==0)) {
         $pulribu='';
        }
        if ($pulribu) {
         $bilangan=$bilangan.' '.$pulribu;
        } 
      }
     }          
     if ($sat==4) {
       $tmp=$pss[0];
       if ($tmp==1) { $ribu='Seribu';}
       else {$ribu=nama($tmp).' Ribu';}
       $bilangan=$ribu;
     }    
    if ($sat > 2) {
       $n=3;
       $tmp=$pss[$sat-$n];
       if ($tmp==1) { $ratus='Seratus'; } else {
       $ratus=nama($tmp).' Ratus';}
       if ($pss[$sat-$n]==0) { $ratus='';}
       if ($ratus) {
        $bilangan.=' '.$ratus;
       } 
    }       
    if ($sat > 1) {
      if ($pss[$sat-2]==1) {
        if (($pss[$sat-2]==1)  &&  ($pss[$sat-1] !=0) && ($pss[$sat-1] !=1)) {
          $tmp=$pss[$sat-1];
          $bilangan.=' '.nama($tmp).'belas';
        } else {
           if ($pss[$sat-1] ==0) {$bilangan.=' Sepuluh';}
           if ($pss[$sat-1] ==1) {$bilangan.=' Sebelas';}           
        }
      } else {
          $tmp=$pss[$sat-2];        
          $tmp2=$pss[$sat-1];
          if (($tmp !=0) && ($tmp2 !=0)) {
            $bilangan.=' '.nama($tmp).' Puluh '.nama($tmp2);
          }
          if (($tmp==0) && ($tmp2 !=0)) {         
            $bilangan.=' '.nama($tmp2);
          }
          if (($tmp!=0) && ($tmp2 ==0)) {                   
           $bilangan.=' '.nama($tmp).' Puluh';
          }        
      }
    }
    return $bilangan; 
}


sub nama {
  for ($_[0]) {
        if  ($_[0]==1)  { $cc='Satu' }     # do something
        elsif ($_[0]==2)  {$cc='Dua'}     # do something else
        elsif ($_[0]==3)  {$cc='Tiga'}     # do something else
        elsif ($_[0]==4)  {$cc='Empat'}     # do something else
        elsif ($_[0]==5)  {$cc='Lima'}     # do something else
        elsif ($_[0]==6)  {$cc='Enam'}     # do something else
        elsif ($_[0]==7)  {$cc='Tujuh'}     # do something else
        elsif ($_[0]==8)  {$cc='Delapan'}     # do something else
        elsif ($_[0]==9)  {$cc='Sembilan'}     # do something else
        elsif ($_[0]==0)  {$cc='Nol'}     # do something else
        return $cc;
    } 
}

sub date_name {
   ($tanggal) = @_ ;  
   %tmp_month=("01","Jan","02","Feb","03","Mar","04","Apr","05","May","06","Jun","07","Jul","08","Aug","09","Sep","10","Oct","11","Nov","12","Dec");
   @tgl = split (/\//,$tanggal);   
   $tt=$tgl[1]."-$tmp_month{$tgl[0]}-".$tgl[2];
   return $tt;
}

sub datetime_name {
   ($tanggal) = @_ ;  
   %tmp_month=("01","Jan","02","Feb","03","Mar","04","Apr","05","May","06","Jun","07","Jul","08","Aug","09","Sep","10","Oct","11","Nov","12","Dec");
   @tgldate=split(/\s+/,$tanggal);   
   $tt=$tgldate[2].'-'.$tgldate[1].'-'.$tgldate[4].' '.$tgldate[3];
   return $tt;
}

sub thntgl {
  $aa=$_[0];
  @tmp_tgl=split(/\s+/,localtime);
  $tmp_tgl[2]=~s/^([1-9])$/0$1/;
  if (length($tmp_tgl[2])<2) {
    $tmp_tgl[2]='0'.$tmp_tgl[2];
  }
 %tmp_bln=(Jan,"01",Feb,"02",Mar,"03",Apr,"04",May,"05",Jun,"06",Jul,"07",Aug,"08",Sep,"09",Oct,"10",Nov,"11",Dec,"12");
 $thntgl="$tmp_tgl[4]$tmp_bln{$tmp_tgl[1]}$tmp_tgl[2]";
 $bb=substr($thntgl,0,$aa);
 return $bb;
} 

sub yyyymmdd {
  @tmp_tgl=split(/\s+/,localtime);
  $tmp_tgl[2]=~s/^([1-9])$/0$1/;
  if (length($tmp_tgl[2])<2) {
    $tmp_tgl[2]='0'.$tmp_tgl[2];
  }
 %tmp_bln=(Jan,"01",Feb,"02",Mar,"03",Apr,"04",May,"05",Jun,"06",Jul,"07",Aug,"08",Sep,"09",Oct,"10",Nov,"11",Dec,"12");
 $bb="$tmp_tgl[4]-$tmp_bln{$tmp_tgl[1]}-$tmp_tgl[2]";
 return $bb;
} 

sub date_weekday {
use Date::Calc qw(Day_of_Week);
   ($tanggal) = @_ ;  
   %tmp_month=("01","Jan","02","Feb","03","Mar","04","Apr","05","May","06","Jun","07","Jul","08","Aug","09","Sep","10","Oct","11","Nov","12","Dec");
   @tgldate=split(/\s+/,$tanggal);   
   $dow = Day_of_Week($tgldate[4],$tgldate[1],$tgldate[2]);
   return $dow;
}

sub date_addday {
use Date::Calc qw(Add_Delta_Days);
   ($tanggal,$hari) = @_ ;  
   @tglNow=split(/\//,$tanggal);
    ($y0, $m0, $d0) = Add_Delta_Days($tglNow[2],$tglNow[0],$tglNow[1],$hari); 
     if (length($m0)<2) {
        $m0='0'.$m0;
     }
     if (length($d0)<2) {
        $d0='0'.$d0;
     }
   $tglnew=$m0.'/'.$d0.'/'.$y0;     
   return $tglnew;
}

sub use_numeral {
  print qq~
  <script src="/js/cleave.js"></script>
  <style>
   .input-harga {
      text-align: right;
   }    
   .input-qty {
      text-align: right;   
   }
  </style>
  
  <script>
  // number
   var cleaveNumeral = new Cleave('.input-harga', {
    numeral: true
   });

   var cleaveQty = new Cleave('.input-qty', {
    numeral: true
   });
  </script>~;   
}

1


