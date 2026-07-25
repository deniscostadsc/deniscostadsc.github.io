FROM jekyll/jekyll:pages

WORKDIR /srv/jekyll

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 4000 35729

CMD ["sh", "-c", "bundle exec jekyll build && bundle exec jekyll serve --host 0.0.0.0 --livereload"]