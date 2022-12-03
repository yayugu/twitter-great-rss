FROM ruby:2.5
RUN apt update && apt install -y nodejs
RUN mkdir /fastladder
ADD . /fastladder
WORKDIR /fastladder
RUN gem install bundler:1.17.3 && bundle -j9
ENV PORT=3000 RAILS_ENV=production
RUN ./bin/rake assets:precompile
EXPOSE 3000
CMD bin/rails db:migrate && bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RAILS_ENV}
