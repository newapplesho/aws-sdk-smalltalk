instance creation
default
	| notifications |
	notifications := self new.
	notifications progressing:''.
	notifications completed:''.
	notifications warning:''.
	notifications error:''.
	^ notifications