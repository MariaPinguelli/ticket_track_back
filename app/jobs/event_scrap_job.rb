class EventScrapJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "------------------- Iniciando Scraper -------------------"

    client = Selenium::WebDriver::Remote::Http::Default.new
    client.read_timeout = 180 # seconds
    path = 'C:\Users\Maria Fernanda\Desktop\ticket_track_back\storage\new_events.json'
    File.open(path, 'w')

    # Selenium::WebDriver::Chrome::Service.driver_path = 'c:\WebDriver\chromedriver-win64\chromedriver-win64\chromedriver.exe'
    options = Selenium::WebDriver::Chrome::Options.new
    # options.add_argument('--no-sandbox')
    # options.add_argument('--headless')

    # Inicializar o driver com as opções
    scraper = Selenium::WebDriver.for(:chrome, options: options, http_client: client)

    # Definir plataformas
    sympla = 'https://www.sympla.com.br/eventos/show-musica-festa/todos-eventos'

    # Navegar para a página desejada
    scraper.get "#{sympla+'?page=1'}"

    # Configurar evento de espera
    wait = Selenium::WebDriver::Wait.new(timeout: 10)

    # Fechar cookies
    wait.until { scraper.find_element(:css, '#onetrust-banner-sdk .onetrust-close-btn-ui') }
    close_cookie = scraper.find_element(:css, '#onetrust-banner-sdk .onetrust-close-btn-ui');
    close_cookie.click

    scraper.action.scroll_by(0, 700).perform
    wait.until { scraper.find_elements(tag_name: 'button').size > 0 }
    page_buttons = scraper.find_elements(tag_name: 'button')
    pages_count = 0

    page_buttons.each_with_index do |button, index|
      text = button.text
      if text.match?(/\A-?\d+\Z/)
        pages_count = text.to_i > pages_count ? text.to_i : pages_count
      end
    end

    pages_count = 1
    pages_count.times { |pg_num| 
      puts "\n\n------ Página #{pg_num+1} ------"
      current_page = "#{sympla+'?page='+(pg_num+1).to_s}"
      scraper.get current_page
      # Esperar até que os elementos estejam presentes
      wait.until { scraper.find_elements(class: 'sympla-card').size > 0 }

      events_list = scraper.find_elements(class: 'sympla-card')

      events_list.each_with_index do |event, index|
        begin
          # Re-obter o elemento logo antes de interagir com ele
          scraper.action.scroll_by(0, 100).perform
          wait.until{ scraper.find_elements(class: 'sympla-card')[index] }
          event = scraper.find_elements(class: 'sympla-card')[index]

          # Role para o elemento e aguarde até que ele esteja clicável
          scraper.action.scroll_to(event).perform;
          wait.until { event.displayed? && event.enabled? }

          # Tente clicar no elemento
          event.click

          # Pegar o título do evento
          title = scraper.find_element(tag_name: 'h1').text
          puts "-------------------"
          puts "#{index} - #{title}"
          description = ""
          
          description_items = scraper.find_elements(css: 'div > p > span')
          description_items.each do |item|
            description += " #{item.text}"
          end
          date = scraper.find_element(css: 'section > div > div > div > div > p').text
          address = scraper.find_element(css: 'div > div > p').text
          
          url = scraper.current_url

          puts "description #{description}"
          puts "date #{date}"
          puts "address #{address}"
          puts "url #{url}"
          # puts "dados #{dados}"
          # puts "new_event #{new_event}"
          puts "path #{path}"

          begin
            file = File.read(path)
            puts "\nfile #{file.class; file.empty?}"
            dados = file.empty? ? [] : JSON.parse(file)  
          rescue => e
            puts "ERRO #{e.message}"
          end

          new_event = {
            name: title,
            description: description,
            date: date,
            address: address,
            url: url
          }

          dados << new_event

          File.open(path, 'w') do |file|
            file.write(JSON.pretty_generate(dados))
          end

          # Voltar para a página anterior
          scraper.get current_page
        rescue Selenium::WebDriver::Error::ElementClickInterceptedError
          puts "Elemento no índice #{index} não pode ser clicado."
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          puts "Erro ao processar o elemento no índice #{index}: stale element reference"
        rescue => e
          puts "Erro ao processar o elemento no índice #{index}: #{e.message}"
        end
      end
    }

    create_new_events(path)

    # Encerrar o scraper
    scraper.quit

    puts "------------------- Encerrando Scraper ------------------"

  end
end

private

def create_new_events(path)
  file = File.read(path)
  new_data = file.empty? ? [] : JSON.parse(file)

  new_data.each_with_index do |new_event, index|
    event = Event.find_by(name: new_event['name'])

    unless event
      begin
        Event.create(name: new_event['name'], date: new_event['date'], description: new_event['description'],)
      rescue => e
        puts "Erro ao criar novo evento: #{e.message}"
      end
    else
      puts "Evento já cadastrado :)"
    end

  end
end
