


# Makefile to build PDF and Markdown cv from YAML.
#
# Brandon Amos <http://bamos.github.io> and
# Ellis Michael <http://ellismichael.com>

# local folder that CV is in
CV_DIR=/n/groups/datta/tim_sainburg/projects/curriculum_vitae

# local folder the website is in 
WEBSITE_DIR=/n/groups/datta/tim_sainburg/projects/timsainburg.com#content/pages/cv.md

# where the cv that gets embedded within the page saves to
CV_PAGE_HTML = $(CV_DIR)/cv/cv_pelican.html
# where to copy the CV html in the website
WEBSITE_PAGE_HTML = $(WEBSITE_DIR)/content/pages/cv_page.html

# where the printable CV saves to
CV_HTML = $(CV_DIR)/cv/cv.html
# where to save the printable CV on the website
CV_WEBSITE = $(WEBSITE_DIR)/content/assets/html/curriculumvitae.html

CV_CSS = $(CV_DIR)/style/cv.css
WEBSITE_CV_CSS = $(WEBSITE_DIR)/content/assets/css/cv.css

.PHONY: default generate stage build prepwebsite buildwebsite push cvpush

# make the html file
generate:
	python3 generate.py

stage: 
	#copy generated pelican HTML to website page
	cp $(CV_PAGE_HTML) $(WEBSITE_PAGE_HTML)
	#copy generated css to website
	cp $(CV_CSS) $(WEBSITE_CV_CSS)
	#copy generated css to website
	cp $(CV_HTML) $(CV_WEBSITE)


# generate the cv, move it to the website, stage it for publishing
build: generate stage

prepwebsite: 
	cd $(WEBSITE_DIR) && $(MAKE) publish

# build, then publish the website
buildwebsite: build prepwebsite

websitepush: 
	git -C $(WEBSITE_DIR) add $(CV_WEBSITE) $(WEBSITE_CV_CSS) $(WEBSITE_PAGE_HTML)
	git -C $(WEBSITE_DIR) commit -m "Update cv."
	git -C $(WEBSITE_DIR) push

cvpush:
	git add *
	git commit -m "Update cv."
	git push

buildpushall: buildwebsite cvpush
