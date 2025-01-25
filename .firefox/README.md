# Firefox Tree Style Tab
- https://addons.mozilla.org/en-US/firefox/addon/tree-style-tab/

# Instruction
When using this extension, the native tab bar becomes obsolete. The following part of the post is an instruction on how to hide the native tab bar:

- Type about:support into the address bar.
- Look for the Profile Folder entry and click on Open folder.
- Create a file named chrome/userChrome.css in the directory:
- `mkdir chrome`
- Copy the style file with  `cp ./chrome/userChrome.css <mozilla_dir>/.mozilla/firefox/05xaq55f.default/chrome/userChrome.css`
- Type [about:config] into the address bar and set `toolkit.legacyUserProfileCustomizations.stylesheets` to true.
- Restart Firefox
- Now the native tab should be hidden. To reset the change simply remove the userCrhome.css file.

