## Release flow


1. Cut a release branch from master
2. `make bump_version`
3. Update `CHANGELOG.md`
4. Push to remote repository and make a release PR

```
$ git branch
* master

$ git checkout -b release/0.4.20
$ make bump_version 0.4.20
$ vim CHANGELOG.md # Update CHANGELOG.md
$ git push origin HEAD
```

5. After merged release PR, tag and push the new version
6. Wait `artifact` CI job which update CocoaPods version, Homebrew bottle, and Homebrew tap
7. Completed :tada:

```
$ git branch
* master

$ git tag 0.4.20
$ git push origin 0.4.20
```

