# Change file names to reflect topic/map title

A Python script which runs on an input folder containing the DITA XML project, copies all content
to the output folder and then renames all topics and maps to better match the titles. The internal links and content references between topics are also updated.

Usage example:

    python3 renameFileUsingTitle.py /Users/../Documents/userguide /Users/.../Documents/userguide-output

As a best practice, as this script is experimental, after you apply the script you should use the "Validate and check for completeness" action from the DITA Maps Manager view on the DITA Map from the generated output folder to check if all links still work.
