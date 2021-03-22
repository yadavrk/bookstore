class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]

  # GET /books or /books.json
  def index
    @books = Book.all
  end

  # GET /books/1 or /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)
    if @book.save
      puts "author ids: #{params[:authors]}"
      if params[:author_ids]
        authors_ids = params[:author_ids].reject(&:empty?).map(&:to_i)
        puts "author ids in if: #{authors_ids}"
        authors = Author.where(id: authors_ids)
        @book.authors << authors
      end
      redirect_to books_path, notice: "Book created"
    else
      render 'new'
    end

    # respond_to do |format|
    #   if @book.save
    #     format.html { redirect_to @book, notice: "Book was successfully created." }
    #     format.json { render :show, status: :created, location: @book }
    #   else
    #     format.html { render :new, status: :unprocessable_entity }
    #     format.json { render json: @book.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    if @book.update(book_params)
      if params[:author_ids]
        authors_ids = params[:author_ids].reject(&:empty?).map(&:to_i)
        puts "author ids in if: #{authors_ids}"
        new_selected_authors = Author.where(id: authors_ids)
        old_selected_authors = @book.authors
        need_to_delete = old_selected_authors - new_selected_authors
        need_to_add = new_selected_authors - old_selected_authors
        @book.authors.delete(need_to_delete)
        @book.authors << need_to_add
      else
        @book.authors.clear
      end
      redirect_to @book, notice: "Book was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
    # respond_to do |format|
    #   if @book.update(book_params)
    #     format.html { redirect_to @book, notice: "Book was successfully updated." }
    #     format.json { render :show, status: :ok, location: @book }
    #   else
    #     format.html { render :edit, status: :unprocessable_entity }
    #     format.json { render json: @book.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:title, :author_ids => [])
    end
end
