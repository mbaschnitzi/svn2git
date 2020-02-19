load 'common'

@test 'copying an empty directory should put empty .gitignore file to copy with empty-dirs parameter' {
    svn mkdir dir-a
    svn commit -m 'add dir-a'
    svn cp dir-a dir-b
    svn commit -m 'copy dir-a to dir-b'

    cd "$TEST_TEMP_DIR"
    svn2git "$SVN_REPO" --empty-dirs --rules <(echo "
        create repository git-repo
        end repository

        match /
            repository git-repo
            branch master
        end match
    ")

    assert git -C git-repo show master:dir-a/.gitignore
    assert_equal "$(git -C git-repo show master:dir-a/.gitignore)" ''
    assert git -C git-repo show master:dir-b/.gitignore
    assert_equal "$(git -C git-repo show master:dir-b/.gitignore)" ''
}

@test 'copying a directory with empty sub-dirs should put empty .gitignore files to empty directories with empty-dirs parameter' {
    svn mkdir --parents dir-a/subdir-a
    svn commit -m 'add dir-a/subdir-a'
    svn cp dir-a dir-b
    svn commit -m 'copy dir-a to dir-b'

    cd "$TEST_TEMP_DIR"
    svn2git "$SVN_REPO" --empty-dirs --rules <(echo "
        create repository git-repo
        end repository

        match /
            repository git-repo
            branch master
        end match
    ")

    assert git -C git-repo show master:dir-a/subdir-a/.gitignore
    assert_equal "$(git -C git-repo show master:dir-a/subdir-a/.gitignore)" ''
    assert git -C git-repo show master:dir-b/subdir-a/.gitignore
    assert_equal "$(git -C git-repo show master:dir-b/subdir-a/.gitignore)" ''
}
