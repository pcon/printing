/*This is a module for openscad to be able to output multiple parts
It pairs with a python script that actually managed the multi-output.

https://traverseda.github.io/code/partsScad/index.html
*/
multiPartOutput = false;
multiPartFirstRun = false;
multiPartBuildMode = "default";

module part(partName, c = undef, buildmode="default") {
	if (multiPartFirstRun) {
		echo("Defined new part ---", partName);
		echo("Color ---", partName, c);
	}

	if (buildmode==multiPartBuildMode) {
		if (!multiPartOutput) {
			color(c=c)children();
		}

		if (multiPartOutput == partName) {
			color(c=c)children();
		}
	}
}