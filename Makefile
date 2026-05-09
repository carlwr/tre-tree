SHELL         =  /usr/bin/env zsh
.SHELLFLAGS  +=  -eu


# readme:

tre-zsh          :=  tre.zsh
tre-help         :=  tre -h
readme-preamble  :=  assets/readme-preamble.md
readme-target    :=  README.md

.PHONY: write-readme
write-readme:
	@ { cat $(readme-preamble) \
	    && print \
	    && print '```' \
	    && source $(tre-zsh) && $(tre-help) \
	    && print '```' \
	  } >$(readme-target)


# create a test dir:

test-dir  :=  .aux/exampleDir
touch-p   :=  () { mkdir -p $${1:h} && touch $$1; }

.PHONY: create-test-dir
create-test-dir:
	rm -rf $(test-dir)
	mkdir -p   $(test-dir)/.dotted-dir/
	$(touch-p) $(test-dir)/.git/gitFile
	$(touch-p) $(test-dir)/.tox/sub/.keepme
	$(touch-p) $(test-dir)/.tox/toxFile
	$(touch-p) $(test-dir)/sub/.git
	$(touch-p) $(test-dir)/sub/f
	$(touch-p) $(test-dir)/file
	$(touch-p) $(test-dir)/git-2-OtherIgnored_01
	$(touch-p) $(test-dir)/gitIgn-2-Other
	$(touch-p) $(test-dir)/gitIgnored_01
	$(touch-p) $(test-dir)/gitIgnOther
	$(touch-p) $(test-dir)/gitOtherIgnored_01
	cat       >$(test-dir)/.gitignore <<<'gitIgnored_*'
