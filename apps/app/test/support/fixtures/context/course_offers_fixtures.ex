defmodule App.Context.CourseOffersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `App.Context.CourseOffers` context.
  """

  @doc """
  Generate a course_offer.
  """
  def course_offer_fixture(attrs \\ %{}) do
    {:ok, course_offer} =
      attrs
      |> Enum.into(%{

      })
      |> App.Context.CourseOffers.create_course_offer()

    course_offer
  end
end
