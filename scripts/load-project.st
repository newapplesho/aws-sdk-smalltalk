"Load (or reload) aws-sdk-smalltalk into the current Pharo image.
 This is the single source of truth for the load expression.
 Run from the repository root with: make load
 Or paste into the Playground and Ctrl+D."
Metacello new
	baseline: 'AWS';
	repository: 'tonel://' , (FileLocator imageDirectory / '..' / 'src') resolve fullName;
	onConflict: [ :ex | ex allow ];
	load.
