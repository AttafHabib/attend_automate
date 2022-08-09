defmodule App.Context.CourseOffersTest do
  use App.DataCase

  alias App.Context.CourseOffers

  describe "course_offers" do
    alias App.Schema.CourseOffer

    import App.Context.CourseOffersFixtures

    @invalid_attrs %{}

    test "list_course_offers/0 returns all course_offers" do
      course_offer = course_offer_fixture()
      assert CourseOffers.list_course_offers() == [course_offer]
    end

    test "get_course_offer!/1 returns the course_offer with given id" do
      course_offer = course_offer_fixture()
      assert CourseOffers.get_course_offer!(course_offer.id) == course_offer
    end

    test "create_course_offer/1 with valid data creates a course_offer" do
      valid_attrs = %{}

      assert {:ok, %CourseOffer{} = course_offer} = CourseOffers.create_course_offer(valid_attrs)
    end

    test "create_course_offer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CourseOffers.create_course_offer(@invalid_attrs)
    end

    test "update_course_offer/2 with valid data updates the course_offer" do
      course_offer = course_offer_fixture()
      update_attrs = %{}

      assert {:ok, %CourseOffer{} = course_offer} = CourseOffers.update_course_offer(course_offer, update_attrs)
    end

    test "update_course_offer/2 with invalid data returns error changeset" do
      course_offer = course_offer_fixture()
      assert {:error, %Ecto.Changeset{}} = CourseOffers.update_course_offer(course_offer, @invalid_attrs)
      assert course_offer == CourseOffers.get_course_offer!(course_offer.id)
    end

    test "delete_course_offer/1 deletes the course_offer" do
      course_offer = course_offer_fixture()
      assert {:ok, %CourseOffer{}} = CourseOffers.delete_course_offer(course_offer)
      assert_raise Ecto.NoResultsError, fn -> CourseOffers.get_course_offer!(course_offer.id) end
    end

    test "change_course_offer/1 returns a course_offer changeset" do
      course_offer = course_offer_fixture()
      assert %Ecto.Changeset{} = CourseOffers.change_course_offer(course_offer)
    end
  end
end
