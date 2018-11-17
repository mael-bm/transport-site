defmodule TransportWeb.API.DiscussionController do
  use TransportWeb, :controller

  alias Transport.Datagouvfr.Client.Discussions

  def post_discussion(conn, %{"comment" => comment,
                              "id_" => id_,
                              "title" => title,
                              "dataset_slug" => dataset_slug}) do
    conn
    |> Discussions.post(id_, title, comment)
    |> case do
      {:ok, _} -> conn
      |> put_flash(:info, dgettext("page-dataset-details", "New discussion started"))
    {:error, error} -> conn
      |> put_flash(:error, dgettext("page-dataset-details", "Unable to start a new discussion"))
    end
    |> redirect(to: dataset_path(conn, :details, dataset_slug))
  end

  def post_answer(conn, %{"id_" => id_, "comment" => comment, "dataset_slug" => dataset_slug}) do
    conn
    |> Discussions.post(id_, comment)
    |> case do
      {:ok, _} -> conn
        |> put_flash(:info, dgettext("page-dataset-details", "Answer published"))
      {:error, error} -> conn
        |> put_flash(:error, dgettext("page-dataset-details", "Unable to publish the answer"))
      end
    |> redirect(to: dataset_path(conn, :details, dataset_slug))
  end
end
