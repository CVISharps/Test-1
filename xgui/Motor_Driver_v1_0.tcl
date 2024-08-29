# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_FREQ" -parent ${Page_0}

  #Adding Page
  set _Clocks_ [ipgui::add_page $IPINST -name "_Clocks_"]
  ipgui::add_static_text $IPINST -name "clock_text" -parent ${_Clocks_} -text {Enter the target frequency for the input clock(s) for the IP.
These frequencies will be used during the default out-of-context synthesis flow}


}

proc update_PARAM_VALUE.C_FREQ { PARAM_VALUE.C_FREQ } {
	# Procedure called to update C_FREQ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_FREQ { PARAM_VALUE.C_FREQ } {
	# Procedure called to validate C_FREQ
	return true
}


proc update_MODELPARAM_VALUE.C_FREQ { MODELPARAM_VALUE.C_FREQ PARAM_VALUE.C_FREQ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_FREQ}] ${MODELPARAM_VALUE.C_FREQ}
}

