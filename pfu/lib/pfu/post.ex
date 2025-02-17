defmodule Pfu.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string
    field :likes, :integer, default: 0
    field :replies, :integer, default: 0
    belongs_to :user, Pfu.User

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:content, :user_id, :likes])
    |> cast(attrs, [:content, :user_id, :replies])
    |> validate_required([:content, :user_id])
    |> validate_length(:content, max: 5000)
  end
end
