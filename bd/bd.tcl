
proc propagate {cellpath otherInfo} {

set cell [get_bd_cells $cellpath]

  # C_FREQ
  set freq [get_property -quiet CONFIG.FREQ_HZ [get_bd_pins $cellpath/aclk_i]]
  if {[string length $freq] > 0 && $freq != 0} {
    set_property CONFIG.C_FREQ $freq $cell
  }

  
}

