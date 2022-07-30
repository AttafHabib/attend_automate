defmodule App.Context do
  import Ecto.Query, warn: false
  alias App.Repo

  @spec list(struct()) :: list(struct()) | []
  def list(model, opts \\ []) when is_list(opts) do
    query_order_opts(model, opts)
    |> Repo.all()
  end

  def query_order_opts(modal, opts) do
    sort = Keyword.get(opts, :sort, :asc)
    case Keyword.get(opts, :sort_by) do
      nil -> modal

      sort_by when is_list(sort_by) ->
       Enum.reduce(sort_by, modal, &order_by(&2, [{^sort, ^&1}]))

      sort_by ->
        modal
        |> order_by([{^sort, ^sort_by}])
    end
  end

  def list(model, limit) do
    case limit do
      0 -> (from model)
      _ -> (from model, limit: ^limit)
    end
    |> Repo.all()
  end

  def list(model,limit,offset) do
    (from a in model,
          limit: ^limit,
          offset: ^offset)
    |> Repo.all()
  end

  def list(model,limit,offset,_sort) do
    (from a in model,
          limit: ^limit,
          offset: ^offset,
          order_by: fragment("lower(concat(?, ' ', ?))", a.first_name, a.last_name)
      )
    |> Repo.all()
  end

  def count(model)do
    Repo.aggregate(model, :count)
  end

  @spec get!(struct(), binary()) :: struct() | nil
  def get!(model, id) do
    Repo.get!(model, id)
  end

  @spec get(struct(), binary()) :: struct() | nil
  def get(model, id) do
    Repo.get(model, id)
  end

  def get_selected(model, id) do
    Repo.all(from m in model, where: m.id in ^id)
  end

  @spec preload_selective(struct() | list(struct()), list(any)) :: struct() | nil
  def preload_selective(data, preloads),
      do: Repo.preload(data, preloads)

  @spec create(struct(), map()) :: {:ok, struct()} | {:error, %Ecto.Changeset{}}
  def create(model, attrs \\ %{}) do
    struct(model)
    |> model.changeset(attrs)
    |> Repo.insert()
  end

  @spec update(struct(), struct(), map()) :: {:ok, struct()} | {:error, %Ecto.Changeset{}}
  def update(model, data, attrs) do
    data
    |> model.changeset(attrs)
    |> Repo.update()
  end

  def update_multiple(model, ids, attrs) do
    from(p in model, where: p.id in ^ids, update: [set: ^attrs])
    |> Repo.update_all([])
  end

  def delete_all(modal, ids) when is_list(ids) do
    (from f in modal, where: f.id in ^ids)
    |> Repo.delete_all()
  end

  @spec delete(list(struct())) :: list({:ok, struct()}) | list({:error, %Ecto.Changeset{}})
  def delete(data) when is_list(data) do
    Enum.each(data, &Repo.delete(&1))
  end

  @spec delete(struct()) :: {:ok, struct()} | {:error, %Ecto.Changeset{}}
  def delete(data) do
    Repo.delete(data)
  end

  @spec change(struct(), struct(), map()) :: %Ecto.Changeset{}
  def change(model, data, attrs \\ %{}) do
    model.changeset(data, attrs)
  end

  #  @spec preload_all(struct(), struct()) :: list(struct()) | struct() | nil
  #  def preload_all(data, model) do
  #    name = Module.split(model)
  #           |> List.last()
  #           |> Inflex.pluralize()
  #    context = Module.concat(["Data", "Context", name])
  #    context.preload_all(data)
  #  end
end
