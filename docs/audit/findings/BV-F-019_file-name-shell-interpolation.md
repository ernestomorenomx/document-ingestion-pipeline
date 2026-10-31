# BV-F-019: File names are interpolated inside single quotes in shell commands

- Status: RESOLVED
- Priority: P1
- Component: gate
- Evidence (required): The hash step and the processing-marker step of the original workflow build shell commands with the file name between single quotes. A name containing a single quote breaks the command, and a crafted name could run arbitrary commands on the host through the SSH node. A listing test showed that the hash tool prefixes its output with a backslash for names containing a backslash, and that `find` prints non-ASCII characters as `?` under the plain C locale.
- Hypothesis (required): Rejecting names with quotes, backslashes or control characters before any command sees them removes the exposure. It would be disproved if a file with such a name still reached the hash step.
- Impact: A workflow failure or, in the worst case, command execution on the host, reachable only by placing a file in a synced device.
- Decision: DN-004, rule UNSAFE_NAME, plus a listing command that pins the UTF-8 locale and skips names with control characters.
- Change record: CR-003.
- Verification (required to close): A synthetic file whose name contains a single quote was left in the input folder for four scheduled runs of the gated workflow: all runs succeeded, no marker was created and the file stayed untouched.
- Residual risk: File names with bytes that are not valid UTF-8 are printed with `?` by `find` and are not rejected by name. Open item in DN-004.
